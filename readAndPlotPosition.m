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

a1 = 1;         % length arm
a2 = 1;         % length elbow 
theta1 = 0;     % initial angle a1
theta2 = 0;     % initial angle a2
data = [a1, a2, theta1 , theta2];
%% Loop Plot
disp('Plotting ...')
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')

while double(get(gcf,'CurrentCharacter'))~=27
    clf;
    %d = lpSensor.getQueueSensorData();
    d = lpSensor.getCurrentSensorData();
    disp(d)
    if (~isempty(d))
        [yaw, pitch, roll] = quat2angle(d.quat);
        data(4) = roll; % yaw or roll, depending the position of the sensor on the arm-frame
        funcDrawSensor(data);
    end
end
set(gcf,'WindowStyle','normal');

%% Disconnecting
disp('Done')
if (lpSensor.disconnect())
    disp('Sensor disconnected')
end
