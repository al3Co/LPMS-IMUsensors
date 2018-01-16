%% This is a script that reads data from a single sensor and stores it in a variable
close all
clear
clc
t = cputime;

%% Parameters
nData = 500;     % number of samples to record (seconds / 100)
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

emptyCounter = 0;
counter = 0;
dataIMU = [];

%% Reading Data
disp('Accumulating data...')
while nCount <= nData
    d = lpSensor.getQueueSensorData();
    disp(d)
    if (~isempty(d))
        A = d.acc;
        [r, q, p] = quat2angle(d.quat);
        dataIMU(nCount,:) = [d.timestamp, A(1), A(2), A(3), p, q, r];
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
timeInterval = cputime - t;
fprintf('Total Time: %f.\n', timeInterval);
