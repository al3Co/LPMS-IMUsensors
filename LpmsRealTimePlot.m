close all
clear
clc

%% Parameters
T = 400;        % number of samples to record (seconds / 100)
nCount = 1;     % starting number
fprintf('Script to real time plot LPMS sensor data with %d data width \n', T);

%% Code to Serial port selection
fprintf('%s \n',seriallist);
connectedSerials = seriallist;
x = input(['Which port of the list? [1->' num2str(length(connectedSerials)) ']. Zero to Exit: ']);
if x == 0
    return
end
COMPort = connectedSerials(x);
disp(COMPort)

%% Comunication parameters
baudrate = 921600;          % rate at which information is transferred
lpSensor = lpms1();          % function lpms sensor given by LPMS

accData = zeros(T,3);



%% Connect to sensor
if ( ~lpSensor.connect(COMPort, baudrate) )
    disp('sensor not connected')
    return 
end
disp('sensor connected')

%% Set streaming mode
lpSensor.setStreamingMode();

%% Loop Plot
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
    title(sprintf('ts = %fs', (d.timestamp)))
    drawnow
end

set(gcf,'WindowStyle','normal');
if (lpSensor.disconnect())
    disp('sensor disconnected')
end