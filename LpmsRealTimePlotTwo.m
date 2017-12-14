close all
clear
clc
%% Initial Parameters
samples = 400;          % number of samples to record (seconds / 100)
nCount = 1;             % starting number
fprintf('Script to real time plot LPMS sensor data with %d data width \n', samples);

%% Code to Serial port selection (TODO)
COMPortS1 = '/dev/tty.SLAB_USBtoUART';
COMPortS2 = '/dev/tty.SLAB_USBtoUART2';
%% Comunication parameters
baudrate = 921600;          % rate at which information is transferred
lpSensor1 = lpms1();        % function lpms sensor given by LPMS
lpSensor2 = lpms2();        % function lpms sensor given by LPMS

accDataS1 = zeros(samples,3);
accDataS2 = zeros(samples,3);
%% Connect to sensor 1
disp('Connecting to Sensors')
if ( ~lpSensor1.connect(COMPortS1, baudrate) )
    disp('sensor 1 not connected')
    return 
end
disp('sensor 1 connected')
%% Connect to sensor 2
if ( ~lpSensor2.connect(COMPortS2, baudrate) )
    disp('sensor 2 not connected')
    return 
end
disp('sensor 2 connected')
%% Set streaming mode
disp('Setting streaming mode')
lpSensor1.setStreamingMode();
lpSensor2.setStreamingMode();
%% Loop Plot
disp('Plotting')
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')
   
while double(get(gcf,'CurrentCharacter'))~=27
    nDataS1 = lpSensor1.hasSensorData();
    nDataS2 = lpSensor2.hasSensorData();
    for i=1:nDataS1
        dS1 = lpSensor1.getQueueSensorData();
        dS2 = lpSensor2.getQueueSensorData();
        if nCount == samples
            accDataS1=accDataS1(2:end, :);
            accDataS2=accDataS2(2:end, :);
        else
            nCount = nCount + 1;
        end
        accDataS1(nCount,:) = dS1.acc;
        accDataS2(nCount,:) = dS2.acc;
    end
    plot(1:samples,accDataS1)
    grid on;
    title(sprintf('ts = %fs', dS1.timestamp))
    drawnow
end

set(gcf,'WindowStyle','normal');
if (lpSensor1.disconnect())
    disp('sensor 1 disconnected')
end
if (lpSensor2.disconnect())
    disp('sensor 2 disconnected')
end
