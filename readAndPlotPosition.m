%% This is a script that reads data from a single sensor and stores it in a variable
close all
clear
clc

%% Reading parameters
nData = 500;    % number of samples to record (seconds = nData/ 100)
nCount = 1;     % starting number
fprintf('Script to initialize sensor with %d data range.\n', nData);

%% Code to Serial port selection
COMPort = COMPort();
numOfSensors = length(COMPort);
if numOfSensors ~= 1
    fprintf('Sensor(s) port(s) connected: %d. Review your connections.\n', numOfSensors);
    timeInterval = cputime - t;
    fprintf('Total Time: %f.\n', timeInterval);
    return
else
    fprintf('%d Serial(s) port found.\n', numOfSensors);
end

%% Comunication parameters
baudrate = 921600;          % rate at which information is transferred
lpSensor = lpms();          % function lpms API sensor given by LPMS

%% Connect to sensor

disp('Connecting to sensor ...')
if ( ~lpSensor.connect(COMPort, baudrate) )
    disp('Sensor not connected')
    return 
end
disp('Sensor connected')

%% Setting streaming mode
disp('Setting mode ...')
lpSensor.setStreamingMode();

%% Preparing variables
emptyCounter = 0;
counter = 0;
dataIMU = [];

timeStamp = [];
gyr = [];
acc = [];
mag = [];
angVel = [];
quat = [];
euler = [];
linAcc = [];

%% Reading Data
disp('Accumulating data...')
while nCount <= nData
    d = lpSensor.getQueueSensorData();
    disp(d)
    if (~isempty(d))
        if nCount == 1
            timeIni = d.timestamp;
        end
        timeStamp(nCount,:) = d.timestamp;
        gyr(nCount,:) = d.gyr;
        acc(nCount,:) = d.acc;
        mag(nCount,:) = d.mag;
        angVel(nCount,:) = d.angVel;
        quat(nCount,:) = d.quat;
        euler(nCount,:) = d.euler;
        linAcc(nCount,:) = d.linAcc;
        
        tmpLinAcc = d.linAcc;
        tmpAcc = d.acc;
        tmpangVel = d.angVel;
        [r, q, p] = quat2angle(d.quat);
        dataIMU(nCount,:) = [(d.timestamp - timeIni), tmpAcc(1), tmpAcc(2), tmpAcc(3), tmpangVel(1), tmpangVel(2), tmpangVel(3)];
        nCount=nCount + 1;
    elseif (isempty(d))
        emptyCounter = emptyCounter + 1;
    end
    counter = counter + 1;
end

%% Print information from reading
fprintf('Times with empty data: %d.\n', emptyCounter);
fprintf('Times on cycle: %d.\n', counter);
disp('Done')
if (lpSensor.disconnect())
    disp('Sensor disconnected')
end

%% Plotting
initial = [0 0 0; 0 0 0; 0 0 0]; 
funcFindPosition(dataIMU,initial);

% figure,plot3(linAcc(:,1),linAcc(:,2),linAcc(:,3));
% grid on
% axis on
% xlabel('x');
% ylabel('y');
% zlabel('z');
% title('trajectory of the body');
