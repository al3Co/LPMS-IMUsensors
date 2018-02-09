%% 01.02.18 Reading Arduino and IMU sensors
close all
clear
clc

%% Initialization
disp('Initialization')

% IMU SENSORS
disp('IMU sensors ...')
COMPort1 = 'COM3';      % COM port to which the IMU 1 is connected
COMPort2 = 'COM4';      % COM port to which the IMU 2 is connected
baudrate = 921600;          % rate at which information is transferred
lpSensor1 = lpms();         % object lpms API sensor 1 given by LPMS
lpSensor2 = lpms();         % object lpms API sensor 2 given by LPMS
if ( ~lpSensor1.connect(COMPort1, baudrate) || ~lpSensor2.connect(COMPort2, baudrate) )
    disp('Sensors not connected')
    return 
end
lpSensor1.setStreamingMode();
lpSensor2.setStreamingMode();

% ARDUINO
disp('Arduino ...')
ard = ard('COM5', 'uno');     % COM port to which the Arduino is connected
writeDigitalPin(ard, 'D13', 1);
disp('all set up')

%% Parameters
% data [leng_arm leng_elbow AnglesS1[3] AnglesS2[3]]
a1 = 1;         % length arm
a2 = 1;         % length elbow 
data = [a1, a2, 0 , 0, 0, 0, 0, 0]; 

T = 100;        % number of samples to plot
nCount = 1;
voltageA0 = zeros(T,1);
voltageA1 = zeros(T,1);

%% Reading method
disp('Reading ... ')

figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')
set(gcf,'WindowStyle','normal');
while double(get(gcf,'CurrentCharacter'))~=27
    clf;
    if nCount == T
        voltageA0 = voltageA0(2:end, :);
        voltageA1 = voltageA1(2:end, :);
    else
        nCount = nCount + 1;
    end
    voltageA0(nCount,:) = readVoltage(ard, 'A0'); % Sensor 1 connected to input A0. Already converted to 0-5V
    voltageA1(nCount,:) = readVoltage(ard, 'A1'); % Sensor 2 connected to input A1. Already converted to 0-5V
    dataIMU_1 = lpSensor1.getCurrentSensorData();      % get current IMU 1 data
    dataIMU_2 = lpSensor2.getCurrentSensorData();      % get current IMU 2 data
    
    if (~isempty(dataIMU_1))
        [X, Y, Z] = quat2angle(dataIMU_1.quat, 'XYZ');     % convert quaternions to angles roll, pitch and yaw
        data(3) = X; data(4) = Y; data(5) = Z;
    end
    if (~isempty(dataIMU_2))
        [X, Y, Z] = quat2angle(dataIMU_2.quat, 'XYZ');     % convert quaternions to angles roll, pitch and yaw
        data(6) = X; data(7) = Y; data(8) = Z;
    end
    
    strings = ['IMU 1: ', num2str(rad2deg(data(4))),' IMU 2: ', num2str(rad2deg(data(7))), ' Diff: ', num2str(rad2deg(data(7))-rad2deg(data(4))) ];
    disp(strings)
    
    dataPlot = [voltageA0, voltageA1];
    plot(1:T,dataPlot)
    title(sprintf('Voltage S1 = %fV S2 = %fV', (voltageA0(nCount)), (voltageA1(nCount))))
    grid on;
    axis([0 T 0 5])
    xlabel('Samples') % x-axis label
    ylabel('Voltage') % y-axis label
    drawnow
end

%% Disconnecting devices 
clear a

writeDigitalPin(ard, 'D13', 0);
if (lpSensor1.disconnect() && lpSensor2.disconnect())
    disp('Sensors disconnected')
end
