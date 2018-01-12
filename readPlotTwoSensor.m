close all
clear
clc

%% Parameters
T = 400;        % number of samples to view on plot 
nCountS1 = 1;     % starting number
nCountS2 = 1;     % starting number
fprintf('Script to real time plot LPMS sensor data with %d data width \n', T);

%% Code to Serial port selection
COMPort1 = 'COM3';
COMPort2 = 'COM4';

%% Comunication parameters
baudrate = 921600;          % rate at which information is transferred
lpSensor1 = lpms();          % function lpms API sensor given by LPMS
lpSensor2 = lpms();
dataS1 = [];
dataS2 = [];

%% Data saving
gyrData = zeros(T,3);
accData = zeros(T,3);
magDataS1 = zeros(T,3);
magDataS2 = zeros(T,3);
quatData = zeros(T,4);
eulerData = zeros(T,3);
linAccData = zeros(T,3);

%% Connect to sensor

disp('Connecting to sensor 1 ...')
if ( ~lpSensor1.connect(COMPort1, baudrate) )
    disp('Sensor 1 not connected')
    return 
end
disp('Sensor 1 connected')

disp('Connecting to sensor 2 ...')
if ( ~lpSensor2.connect(COMPort2, baudrate) )
    disp('Sensor 2 not connected')
    return
end
disp('Sensor 2 connected')

%% Setting streaming mode
disp('Setting mode sensor 1 ...')
lpSensor1.setStreamingMode();

disp('Setting mode sensor 2 ...')
lpSensor2.setStreamingMode();

%% Read and Plot method
disp('Plotting ...')
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')
x0=200;
y0=200;
width=650;
height=500;
set(gcf,'units','points','position',[x0,y0,width,height])

while double(get(gcf,'CurrentCharacter'))~=27
    if lpSensor1.hasSensorData() ~= 0
        nDataS1 = lpSensor1.hasSensorData();
        for i=1:nDataS1
            dS1 = lpSensor1.getQueueSensorData();
            if nCountS1 == T
                magDataS1 = magDataS1(2:end, :);
            else
                nCountS1 = nCountS1 + 1;
            end
            magDataS1(nCountS1,:) = dS1.euler;
        end
    end
    
    if lpSensor2.hasSensorData() ~= 0
        nDataS2 = lpSensor2.hasSensorData();
        for i=1:nDataS2
            dS2 = lpSensor2.getQueueSensorData();
            if nCountS2 == T
                magDataS2 = magDataS2(2:end, :);
            else
                nCountS2 = nCountS2 + 1;
            end
            magDataS2(nCountS2,:) = dS2.euler;
        end
    end
    
    ax1 = subplot(2,1,1);
    plot(ax1,1:T,magDataS1)
    title(sprintf('Time Stamp S1 = %fs', (dS1.timestamp)))
    grid on;
    
    ax2 = subplot(2,1,2);
    plot(ax2,1:T,magDataS2)
    title(sprintf('Time Stamp S2 = %fs', (dS2.timestamp)))
    grid on;
    
    axis([ax1 ax2],[0 400 -180 180])
    drawnow
end

%% Disconnecting Sensors

disp('Done')
if (lpSensor1.disconnect())
    disp('Sensor 1 disconnected')
end

if (lpSensor2.disconnect())
    disp('Sensor 2 disconnected')
end
