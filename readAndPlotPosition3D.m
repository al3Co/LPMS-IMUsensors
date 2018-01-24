%% (18-01-2018) This script draw two sensors porition
close all
clear
clc

%% Parameters
fprintf('Script to plot the orientation');

%% Code to Serial port selection
COMPort1 = 'COM3';
COMPort2 = 'COM4';

%% Comunication parameters
baudrate = 921600;          % rate at which information is transferred
lpSensor1 = lpms();         % function lpms API sensor 1 given by LPMS
lpSensor2 = lpms();         % function lpms API sensor 2 given by LPMS

%% Connect to sensor
disp('Connecting to sensors ...')
if ( ~lpSensor1.connect(COMPort1, baudrate) )
    disp('Sensor not connected')
    return 
end
if ( ~lpSensor2.connect(COMPort2, baudrate) )
    disp('Sensor 2 not connected')
    return
end
disp('Sensors connected')

%% Setting streaming mode
disp('Setting mode')
lpSensor1.setStreamingMode();
lpSensor2.setStreamingMode();

%% Physical data
a1 = 1;         % length arm
a2 = 1;         % length elbow 
data = [a1, a2, 0 , 0, 0, 0, 0, 0]; % data to plot

%% Loop Plot
disp('Plotting ...')
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')
set(gcf,'WindowStyle','normal');

while double(get(gcf,'CurrentCharacter'))~=27
    d1 = lpSensor1.getCurrentSensorData();
    d2 = lpSensor2.getCurrentSensorData();
    if (~isempty(d1))
        [X, Y, Z] = quat2angle(d1.quat, 'XYZ');
        data(3) = X; data(4) = Y; data(5) = Z;
    end
    if (~isempty(d2))
        [X, Y, Z] = quat2angle(d2.quat, 'XYZ');
        data(6) = X; data(7) = Y; data(8) = Z;
    end
    funcPlot3DPosV4(data);
end

%% Disconnecting
disp('Done')
if (lpSensor1.disconnect())
    disp('Sensor 1 disconnected')
end
if (lpSensor2.disconnect())
    disp('Sensor 2 disconnected')
end
