%% This is a script that reads data from a single sensor and stores it in a variable
close all
clear
clc
t = cputime;

%% Parameters
nData = 1e3;     % number of samples to record
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

%% Reading Data
disp('Accumulating data...')
while nCount <= nData
    d = lpSensor.getQueueSensorData();
    disp(d)
    if (~isempty(d))
        nCount = nCount + 1;
        [yaw, pitch, roll] = quat2angle(d.quat);
        DrawRotation(yaw, pitch, roll);
    end
end

%% Print information from reading
disp('Done')
if (lpSensor.disconnect())
    disp('Sensor disconnected')
end

timeInterval = cputime - t;
fprintf('Total Time: %f.\n', timeInterval);
