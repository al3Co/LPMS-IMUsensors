close all
clear
clc

%% Parameters
nData = 1000;       % number of samples to record
iniData = 50;       % number of samples for initializing 
nCount = 1;         % starting number for cycles
fprintf('Script to record LPMS sensor data with %d data range.\n', nData);

%% Code to Serial port selection
COMPort = COMPort();
numOfSensors = length(COMPort);
if numOfSensors > 2 || numOfSensors <= 0
    fprintf('%d sensors connected. Review your connections.\n', numOfSensors);
    return
else
    fprintf('%d sensors connected.\n', numOfSensors);
end

%% Comunication parameters      
baudrate = 921600;           % rate at which information is transferred
for n = 1:numOfSensors
    lpSensor(n) = lpms1();          % function lpms API sensor given by LPMS
end

%% Variables used
sensorsState = zeros(1,numOfSensors);   % Variables to know state of sensors connected
ts = zeros(nData,1);    % TimeSample from sensor
%sensorData = zeros(1, numOfSensors);    % Variable used for ...

%% Storages
accDataS1 = zeros(nData,3);
accDataS2 = zeros(nData,3);
quatData = zeros(nData,4);

%% Connecting, setting mode and initializing sensors
emptyCounter = 0;
cycleCounter = 0;
count = 1;
for n = 1:numOfSensors
    fprintf('Connecting to sensor %s ...\n', COMPort(count));
    if ( ~lpSensor(n).connect(COMPort(n), baudrate) )
        fprintf('Sensor %s not connected \n', COMPort(count));
        sensorsState(n) = 1;
    end
    if sensorsState(n) == 0
        fprintf('Setting mode sensor %s ...\n', COMPort(count));
        lpSensor(n).setStreamingMode();
        disp('Setting done.');
        disp('Initializing... ')
        while cycleCounter <= iniData
            d = lpSensor(n).getQueueSensorData();
            if (~isempty(d))
                cycleCounter = cycleCounter + 1;
            elseif (isempty(d))
                emptyCounter = emptyCounter + 1;
            end
        end
        fprintf('Sensor %s ready. \n', COMPort(count));
        emptyCounter = 0;
        cycleCounter = 0;
    end
    count = count + 1;
end

%% Verifying # sensors connected with # ports opened
for n = sensorsState
    if n == 1
        for m = 1:numOfSensors
            if (lpSensor(m).disconnect())
                disp('sensor disconnected')
            end
        end
        disp('Exit')
        return 
    end
end

%% Getting sync data TODO: code for n qty of sensors (Now the code is for two sensors)
disp('Getting data ...')

while nCount <= nData
    
    for n = 1:numOfSensors
        if n == 1
            dS1 = lpSensor(n).getQueueSensorData();
            if (~isempty(dS1))
                accDataS1(nCount,:) = dS1.acc;
            end
        else
            dS2 = lpSensor(n).getQueueSensorData();
            if (~isempty(dS2))
                accDataS2(nCount,:) = dS2.acc;
            end
        end
    end
    if (~isempty(dS1) && ~isempty(dS2))
        nCount=nCount + 1;
        disp(nCount)
    end
end
fprintf('Getting data: %d done.\n', (nCount - 1));

%% Disconnect sensors
disp('Disconnecting ...');
count = 1;
for n = 1:numOfSensors
    if (lpSensor(n).disconnect())
        fprintf('Sensor %d disconnected\n', count);
        count = count + 1;
    end
end
