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
theta1 = 0;     % initial angle a1
theta2 = 0;     % initial angle a2
theta3 = 0;     % initial angle a3
data = [a1, a2, theta1 , theta2, theta3];

%% Loop Plot
disp('Plotting ...')
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')

while double(get(gcf,'CurrentCharacter'))~=27
    d1 = lpSensor1.getCurrentSensorData();
    d2 = lpSensor2.getCurrentSensorData();
    if (~isempty(d1))
        [yawS1, pitchS1, rollS1] = quat2angle(d1.quat);
        data(3) = yawS1; % yaw or roll, depending the position of the sensor on the arm-frame
        data(4) = rollS1; % yaw or roll, depending the position of the sensor on the arm-frame
    end
    if (~isempty(d2))
        [yawS2, pitchS2, rollS2] = quat2angle(d2.quat);
        data(5) = yawS2; % yaw or roll, depending the position of the sensor on the arm-frame
    end
    %funcDrawSensor(data);
    %funcPlot3DPos(data);
    funcPlot3DPosV2(data)
end
set(gcf,'WindowStyle','normal');

%% Disconnecting
disp('Done')
if (lpSensor1.disconnect())
    disp('Sensor 1 disconnected')
end
if (lpSensor2.disconnect())
    disp('Sensor 2 disconnected')
end
