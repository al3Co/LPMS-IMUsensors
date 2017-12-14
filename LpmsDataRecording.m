close all
clear
clc

% Parameters
nData = 500;    % number of samples to record (seconds / 100)
nCount = 1;     % starting number
fprintf('Script to record LPMS sensor data with %d data \n', nData);

% code to Serial port selection
fprintf('%s \n',seriallist);
prompt = 'Which port? [1-16] Zero to Exit: ';
x = input(prompt);
if x == 0
    disp('LPMS Sensors usb virtual COM port(VCP) functionality is disabled by default. Please use VCPConversionTool to enable VCP support.');
    return
end
sCount = 1;
for n = seriallist
    if sCount == x
        COMPort = n;
    end
    sCount = sCount + 1;
end
disp(COMPort)

% Comunication parameters      
baudrate = 921600;          % rate at which information is transferred
lpSensor = lpms();          % function lpms API sensor given by LPMS

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