%% 060218 This is a script that reads data from two sensors and plot its vectors
close all
clear
clc
fprintf('Script to plot Vectors');
%% Code to Serial port selection
COMPort1 = 'COM3';      % COM port to which the sensor 1 is connected
COMPort2 = 'COM4';      % COM port to which the sensor 2 is connected
%% Comunication parameters
baudrate = 921600;          % rate at which information is transferred
lpSensor1 = lpms();         % object lpms API sensor 1 given by LPMS
lpSensor2 = lpms();         % object lpms API sensor 2 given by LPMS
%% Connect to sensor
disp('Connecting to sensors ...')       % Method to connect to the sensors using attributes from lpms object
if ( ~lpSensor1.connect(COMPort1, baudrate) || ~lpSensor2.connect(COMPort2, baudrate) )
    disp('Sensors not connected')
    return
else
    disp('Sensors connected')
end
%% Setting streaming mode
disp('Setting Streaming mode')
lpSensor1.setStreamingMode();
lpSensor2.setStreamingMode();
%% Parameters
angleSens = [0 0 0 0 0 0];
%% Loop Plot
disp('Plotting ...')
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')
set(gcf,'units','points','position',[350,100,600,600])
while double(get(gcf,'CurrentCharacter'))~=27
    d1 = lpSensor1.getCurrentSensorData();      % get current sensor data
    d2 = lpSensor2.getCurrentSensorData();      % get current sensor data
    if (~isempty(d1) && ~isempty(d2))
        [pitchS1, rollS1, yawS1] = quat2angle(d1.quat, 'YXZ');     % convert quaternions to angles roll, pitch and yaw
        angleSens(1) = rollS1; angleSens(2) = pitchS1; angleSens(3) = yawS1;
        [pitchS2, rollS2, yawS2] = quat2angle(d2.quat, 'YXZ');     % convert quaternions to angles roll, pitch and yaw
        angleSens(4) = rollS2; angleSens(5) = pitchS2; angleSens(6) = yawS2;
        linearAcc = [d1.linAcc, d2.linAcc];             % linear Acceleration
        [positions, angleR] = funcPlotVector2S(angleSens, linearAcc);        % plot and return positions
    end
end
%% Disconnecting
disp('Done')
if (lpSensor1.disconnect() && lpSensor2.disconnect())
    disp('Sensors disconnected')
end
