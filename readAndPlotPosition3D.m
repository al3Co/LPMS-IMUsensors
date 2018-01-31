%% (18-01-2018) This script draw two sensors porition
% Packages used:
% LPMS API for Matlab
% quat2angle from Aerospace Toolbox https://es.mathworks.com/help/aerotbx/ug/quat2angle.html
% funcPlot3DPosV4 for position calculation and plot

%%
close all
clear
clc

%% Initial disp
disp('Script to plot position from two LPMS-URS2 sensors')

%% Code to Serial port selection
COMPort1 = 'COM3';      % COM port to which the sensor 1 is connected
COMPort2 = 'COM4';      % COM port to which the sensor 2 is connected

%% Comunication parameters
baudrate = 921600;          % rate at which information is transferred
lpSensor1 = lpms();         % object lpms API sensor 1 given by LPMS
lpSensor2 = lpms();         % object lpms API sensor 2 given by LPMS

%% Connect to sensor
% Method to connect to the sensors using attributes from lpms object
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
% data [leng_arm leng_elbow AnglesS1[3] AnglesS2[3]]
a1 = 1;         % length arm
a2 = 1;         % length elbow 
data = [a1, a2, 0 , 0, 0, 0, 0, 0]; 

%% Loop Plot
disp('Plotting ...')
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')
set(gcf,'WindowStyle','normal');
% create a figure and keep it until it closes 
while double(get(gcf,'CurrentCharacter'))~=27
    d1 = lpSensor1.getCurrentSensorData();      % get current sensor data
    d2 = lpSensor2.getCurrentSensorData();      % get current sensor data
    if (~isempty(d1))
        [X, Y, Z] = quat2angle(d1.quat, 'XYZ');     % convert quaternions to angles roll, pitch and yaw
        data(3) = X; data(4) = Y; data(5) = Z;
    end
    if (~isempty(d2))
        [X, Y, Z] = quat2angle(d2.quat, 'XYZ');     % convert quaternions to angles roll, pitch and yaw
        data(6) = X; data(7) = Y; data(8) = Z;
    end
    funcPlot3DPosV5(data);
end

%% Disconnecting
disp('Done')
if (lpSensor1.disconnect())
    disp('Sensor 1 disconnected')
end
if (lpSensor2.disconnect())
    disp('Sensor 2 disconnected')
end
