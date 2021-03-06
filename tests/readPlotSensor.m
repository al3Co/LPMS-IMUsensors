close all
clear
clc
t = cputime;

%% Parameters
T = 400;        % number of samples to view on plot 
nCount = 1;     % starting number
fprintf('Script to real time plot LPMS sensor data with %d data width \n', T);

%% Code to Serial port selection
COMPort = COMPort();
numOfSensors = length(COMPort);
if numOfSensors ~= 1
    fprintf('Sensors ports connected: %d. Review your connections.\n', numOfSensors);
    timeInterval = cputime - t;
    fprintf('Total Time: %f.\n', timeInterval);
    return
else
    fprintf('%d Sensor ports connected.\n', numOfSensors);
end

%% Comunication parameters
baudrate = 921600;          % rate at which information is transferred
lpSensor = lpms();          % function lpms sensor given by LPMS

%% Data saving
gyrData = zeros(T,3);
accData = zeros(T,3);
magData = zeros(T,3);
quatData = zeros(T,4);
eulerData = zeros(T,3);
linAccData = zeros(T,3);

%% Connect to sensor
if ( ~lpSensor.connect(COMPort, baudrate) )
    disp('sensor not connected')
    return 
end
disp('Sensor connected')

%% Setting streaming mode
disp('Setting mode ...')
lpSensor.setStreamingMode();

%% Loop Plot
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')
set(gcf,'WindowStyle','normal');
while double(get(gcf,'CurrentCharacter'))~=27
    nData = lpSensor.hasSensorData();
    for i=1:nData
        d = lpSensor.getQueueSensorData();
        if nCount == T
            magData = magData(2:end, :);
        else
            nCount = nCount + 1;
        end
        magData(nCount,:) = d.linAcc;
    end
    plot(1:T,magData)
    grid on;
    title(sprintf('Time Stamp = %fs', (d.timestamp)))
    %axis([0 400 -120 120])
    drawnow
end


if (lpSensor.disconnect())
    disp('sensor disconnected')
end
