close all
clear all
clc

% Parameters
nData = 500;   % number of samples to record
nCount = 1;     % starting number

% Comunication parameters
COMPort = COMPort();        % function with COM port selection
baudrate = 921600;          % rate at which information is transferred
lpSensor = lpms();          % function lpms sensor given by LPMS

ts = zeros(nData,1);
accData = zeros(nData,3);
quatData = zeros(nData,4);

% Connect to sensor
if ( ~lpSensor.connect(COMPort, baudrate) )
    disp('sensor not connected')
    return 
end
disp('sensor connected')

% Set streaming mode
lpSensor.setStreamingMode();

disp('Accumulating sensor data')
while nCount <= nData
    d = lpSensor.getQueueSensorData();
    if (~isempty(d))
        ts(nCount) = d.timestamp;
        accData(nCount,:) = d.acc;
        quatData(nCount,:) = d.quat;
        nCount=nCount + 1;
    end
end
disp('Done')
if (lpSensor.disconnect())
    disp('sensor disconnected')
end

plot(ts-ts(1), accData);
xlabel('timestamp(s)');
ylabel('Acc(g)');
grid on

