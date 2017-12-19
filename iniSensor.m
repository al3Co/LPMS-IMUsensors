%% This is gonna be a function, clear this part and make as function
close all
clear
clc
t = cputime;

%% Parameters
nData = 100;     % number of samples to record (seconds / 100)
nCount = 1;     % starting number
fprintf('Script to initialize sensor with %d data range.\n', nData);

%% Code to Serial port selection
COMPort = COMPort();
numOfSensors = length(COMPort);
if numOfSensors ~= 1
    fprintf('Sensors connected: %d. Review your connections.\n', numOfSensors);
    e = cputime-t
    return
else
    fprintf('%d sensors connected.\n', numOfSensors);
end

%% Comunication parameters      
baudrate = 921600;          % rate at which information is transferred
%baudrate = 576000;          % rate at which information is transferred
lpSensor = lpms1();          % function lpms API sensor given by LPMS


%% Connect to sensor
disp('Connecting sensor ...')
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

%% Reading Data
disp('Accumulating sensor data 1')
while nCount <= nData
    d = lpSensor.getQueueSensorData();
    disp(d)
    if (~isempty(d))
        nCount=nCount + 1;
    elseif (isempty(d))
        emptyCounter = emptyCounter + 1;
    end
    counter = counter + 1;
end

fprintf('Times with empty data: %d.\n', emptyCounter);
fprintf('Times on cycle: %d.\n', counter);
disp('Done')
if (lpSensor.disconnect())
    disp('sensor disconnected')
end
e = cputime-t;
disp(e)
