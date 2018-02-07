%% 070218
% Script to save the data received by IMU, EMG and Flexion from ARDUINO
% sensors to create the "knowledge" of the artificial neural network
close all
clear
clc
%%
disp('Starting')
% ARDUINO
try
    disp('Arduino ...')
    %ard = arduino('COM7', 'Mega2560');     % COM port to which the Arduino is connected
    ard = arduino('COM6', 'uno');
catch msg
    disp(msg)
    return
end
disp('Arduino ready')
% IMU SENSORS
disp('IMU sensors ...')
COMPort1 = 'COM3';          % COM port to which the IMU 1 is connected
COMPort2 = 'COM4';          % COM port to which the IMU 2 is connected
baudrate = 921600;          % rate at which information is transferred
lpSensor1 = lpms();         % object lpms API sensor 1 given by LPMS
lpSensor2 = lpms();         % object lpms API sensor 2 given by LPMS
if ( ~lpSensor1.connect(COMPort1, baudrate) || ~lpSensor2.connect(COMPort2, baudrate) )
    disp('Sensors not connected')
    return 
end
lpSensor1.setStreamingMode();
lpSensor2.setStreamingMode();
disp('Done. All set up')

%% Parameters
voltageArd = [0 0 0];
nCount = 1;

folderName = 'testsData';
[status, msg, msgID] = mkdir(folderName);
dir = [pwd, '\',folderName];
disp(dir)
S = char(datetime('now','Format','yyyy-MM-dd''T''HHmmss'));
fileName = ['name_',S,'.txt'];
fileID = fopen(fullfile(dir,fileName),'wt');

%% Loop Plot
disp('Saving Data ...')
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')
set(gcf,'units','points','position',[350,100,600,600])
while double(get(gcf,'CurrentCharacter'))~=27
    voltageA0 = readVoltage(ard, 'A0');                 % Sensor 1 connected to input A0.
    voltageA1 = readVoltage(ard, 'A1');                 % Sensor 2 connected to input A1.
    voltageA2 = readVoltage(ard, 'A2');                 % Sensor 3 connected to input A2.
    voltageArd = [voltageA0 voltageA1 voltageA2];
    dataIMU1 = lpSensor1.getCurrentSensorData();        % get current IMU1 sensor data
    dataIMU2 = lpSensor2.getCurrentSensorData();        % get current IMU2 sensor data
    %if (~isempty(dataIMU1) && ~isempty(dataIMU2))
    funcStoreDataANN(voltageArd, dataIMU1, dataIMU2, nCount, fileID);
    nCount = nCount +1;
    %end
end
%% Disconnecting
fclose(fileID);
disp('Done')
clear ard
if (lpSensor1.disconnect() && lpSensor2.disconnect())
    disp('Sensors disconnected')
end