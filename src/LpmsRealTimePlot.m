close all
clear
clc

%% Parameters
T = 400;        % number of samples to record (seconds / 100)
nCount = 1;     % starting number
accData = zeros(T,3);
fprintf('Script to real time plot LPMS sensor data with %d data width \n', T);

%% code to Serial port selection
serials = seriallist;
len = length(seriallist);
for serialPort = 1:len
    fprintf('%d - %s \n', serialPort, serials(serialPort));
end
prompt = (['Select port number. [' num2str(len) ' available(s)]. Zero to Exit: ']);
x = input(prompt);
if x == 0
    disp('Aborted')
    return
end
if x > len
    disp('Invalid number')
    return
end
for n = 1:len
    if n == x
        COMPort = serials(n);
    end
end
disp(COMPort)

%% Comunication parameters
baudrate = 921600;          % rate at which information is transferred
lpSensor = lpms();          % function lpms sensor given by LPMS

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
    title(sprintf('ts = %5.2f', d.timestamp))
    drawnow
end
set(gcf,'WindowStyle','normal');

%% disconnect
if (lpSensor.disconnect())
    disp('sensor disconnected')
end
