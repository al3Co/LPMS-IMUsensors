close all
clear all
clc

% Parameters
T = 400;        % number of samples to record
nCount = 1;     % starting number

% Comunication parameters
COMPort = COMPort();        % function with COM port selection
baudrate = 921600;          % rate at which information is transferred
lpSensor = lpms();          % function lpms sensor given by LPMS

accData = zeros(T,3);



% Connect to sensor
if ( ~lpSensor.connect(COMPort, baudrate) )
    disp('sensor not connected')
    return 
end
disp('sensor connected')

% Set streaming mode
lpSensor.setStreamingMode();

% Loop Plot
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')
   
while double(get(gcf,'CurrentCharacter'))~=27
    nData = lpSensor.hasSensorData();
    for i=1:nData
        d = lpSensor.getQueueSensorData();
        if nCount == T
            accData=accData(2:end, :);
        else
            nCount = nCount + 1;
        end
        accData(nCount,:) = d.acc;
    end
    plot(1:T,accData)
    grid on;
    title(sprintf('ts = %fs', d.timestamp))
    drawnow
end

set(gcf,'WindowStyle','normal');
if (lpSensor.disconnect())
    disp('sensor disconnected')
end