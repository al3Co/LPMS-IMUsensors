%% This is a script that reads data from a single sensor and plot its orientation
close all
clear
clc

%% Parameters
fprintf('Script to plot the orientation');

%% Comunication parameters
COMPort = "COM3";
baudrate = 921600;          % rate at which information is transferred
lpSensor = lpms();          % function lpms API sensor given by LPMS

%% Connect to sensor
disp('Connecting to sensor ...')
if ( ~lpSensor.connect(COMPort, baudrate) )
    disp('Sensor not connected')
    return 
end
disp('Sensor connected')

%% Setting streaming mode
disp('Setting mode ...')
lpSensor.setStreamingMode();

%% Loop Plot
disp('Plotting ...')
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')

while double(get(gcf,'CurrentCharacter'))~=27
    d = lpSensor.getQueueSensorData();
    if (~isempty(d))
        [yaw, pitch, roll] = quat2angle(d.quat);
        DrawRotation(yaw, pitch, roll);
    end
end
set(gcf,'WindowStyle','normal');

%% Disconnecting
disp('Done')
if (lpSensor.disconnect())
    disp('Sensor disconnected')
end
