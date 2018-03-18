%% 170318
% Script to save the data received by 2 IMU and 20 FlexSens from ARDUINO
close all
clear
clc
%% COMPort closing
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
disp('Starting')

%% ARDUINO
load('/Users/aldo/Documents/MATLAB/matlab.mat')
numLilys = length(data);
for i=1:numLilys
    fprintf('Connecting Ard #%d\n',i);
    appArduino(i,:) = serial(data(i,2),'BaudRate',9600);
    fopen(appArduino(i))
end
disp('Arduino ready')

%% IMU SENSORS
disp('IMU sensors ...')
COMPort1 = 'COM3';          % COM port to which the IMU 1 is connected
COMPort2 = 'COM4';          % COM port to which the IMU 2 is connected
baudrate = 921600;          % rate at which information is transferred
lpSensor1 = lpms();         % object lpms API sensor 1 given by LPMS
lpSensor2 = lpms();         % object lpms API sensor 2 given by LPMS
if ( ~lpSensor1.connect(COMPort1, baudrate) || ~lpSensor2.connect(COMPort2, baudrate) )
    disp('Sensors not connected')
    return 
end
lpSensor1.setStreamingMode();
lpSensor2.setStreamingMode();
disp('Done. All set up')

%% Parameters
nTotal = 1500;  % samples number
nCount = 1;     % initial sample
dataArd = [];      % variable to save data
nSens = 6;      % number of sensors including zero
Sample = [];    % sample stamp
clockT = [];
StampIMUA = [];
StampIMUB = [];
quatIMUA = [];
quatIMUB = [];
accIMUA = [];
accIMUB = [];

% format incoming data
format = '';
for nSen = 0: nSens
    if nSen < nSens
        format = [format , '%f,'];
    else
        format = [format , '%f'];
    end
end

%% get data
now = tic;
while  nCount < nMax
    dataIMU1 = lpSensor1.getQueueSensorData();        % get queue IMU1 sensor data
    dataIMU2 = lpSensor2.getQueueSensorData();        % get queue IMU2 sensor data
    % Sync Method
    if (~isempty(dataIMU1)) && (~isempty(dataIMU2))
        flagIMUData = true;
    elseif (~isempty(dataIMU1)) && (isempty(dataIMU2))
        while (isempty(dataIMU2))
            dataIMU2 = lpSensor2.getQueueSensorData();
        end
        flagIMUData = true;
    elseif (~isempty(dataIMU2)) && (isempty(dataIMU1))
        while (isempty(dataIMU1))
            dataIMU1 = lpSensor1.getQueueSensorData();
        end
        flagIMUData = true;
    elseif (isempty(dataIMU2)) && (isempty(dataIMU1))
        flagIMUData = false;
    end
    
    if flagIMUData
        % IMUs
        StampIMUA(nCount,:) = [dataIMU1.timestamp];
        StampIMUB(nCount,:) = [dataIMU2.timestamp];
        quatIMUA(nCount,:) = [dataIMU1.quat];
        quatIMUB(nCount,:) = [dataIMU2.quat];
        accIMUA(nCount,:) = [dataIMU1.acc];
        accIMUB(nCount,:) = [dataIMU2.acc];
        Sample(nCount,:) = nCount;
        clockT(nCount,:) = clock;
        
        % Arduinos
        try
            datoInicial = 1;
            for i=1:numLilys
                dataArd(nCount,datoInicial:1:(nSens*i)) = fscanf(arduino(i),format);
                datoInicial = datoInicial + nSens;
            end
            nCount = nCount +1;
        catch
            dips('Serial Arduino Data error')
        end
        
        flagIMUData = false;
        disp([(nMax - nCount) dataIMU1.timestamp dataIMU2.timestamp])
    end
end
time = toc(now);
disp(time)

%% Disconnecting
disp('Disconnecting')
clear appArduino
if (lpSensor1.disconnect() && lpSensor2.disconnect())
    disp('Sensors disconnected')
end


%% https://es.mathworks.com/help/matlab/ref/writetable.html
% https://es.mathworks.com/help/matlab/ref/save.html

% creating table
clockT = [clockT(:,4) clockT(:,5) clockT(:,6)];
T = table(Sample, clockT, StampIMUA, StampIMUB,...
    quatIMUA, quatIMUB, accIMUA, accIMUB, dataArd);

% saving on file
disp('Storing Data to a File')
folderName = 'testsData';
[status, msg, msgID] = mkdir(folderName);
dir = [pwd, '\',folderName];
disp(dir)
S = char(datetime('now','Format','yyyy-MM-dd''T''HHmmss'));
fileName = ['manualMethod_',S,'.txt'];
fileName2 = ['manualMethod_',S,'.mat'];

writetable(T,fileName,'WriteRowNames',true); 
save WorkSpace.mat
