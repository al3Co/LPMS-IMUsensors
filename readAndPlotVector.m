%% This is a script that reads data from a single sensor and plot its vector
close all
clear
clc

%% Parameters
fprintf('Script to plot the Vector');

%% Comunication parameters
COMPort = "COM4";
baudrate = 921600;          % rate at which information is transferred
lpSensor = lpms();          % function lpms API sensor given by LPMS

%% Connect to sensor
if ( ~lpSensor.connect(COMPort, baudrate) )
    disp('Sensor not connected')
    return 
end
disp('Sensor connected')

%% Setting streaming mode
lpSensor.setStreamingMode();
% parameter
%% Loop Plot
disp('Plotting ...')
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')
set(gcf,'WindowStyle','normal');
while double(get(gcf,'CurrentCharacter'))~=27
    %d = lpSensor.getQueueSensorData();
    d = lpSensor.getCurrentSensorData();
    if (~isempty(d))
        [pitch, roll, yaw] = quat2angle(d.quat, 'YXZ');
        funcPlotVectorV2(pitch, roll, yaw);
    end
end

%% Disconnecting
disp('Done')
if (lpSensor.disconnect())
    disp('Sensor disconnected')
end
