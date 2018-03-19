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
nCount = 1; nMax = 1000;
flagIMUData = false;
VA0 = []; VA1 = []; VA2=[];
anglesSensors = []; linearAcc = []; posSensors = [];
Sample = []; timeStamp = [];
%% Loop Plot
now = tic;
while  nCount < nMax
%     dataIMU1 = lpSensor1.getCurrentSensorData();        % get current IMU1 sensor data
%     dataIMU2 = lpSensor2.getCurrentSensorData();        % get current IMU2 sensor data
    dataIMU1 = lpSensor1.getQueueSensorData();        % get queue IMU1 sensor data
    dataIMU2 = lpSensor2.getQueueSensorData();        % get queue IMU2 sensor data
    % Sync Method
    if (~isempty(dataIMU1)) && (~isempty(dataIMU2))
        flagIMUData = true;
    elseif (~isempty(dataIMU1)) && (isempty(dataIMU2))
        while (isempty(dataIMU2))
            dataIMU2 = lpSensor2.getQueueSensorData();
        end
        flagIMUData = true;
    elseif (~isempty(dataIMU2)) && (isempty(dataIMU1))
        while (isempty(dataIMU1))
            dataIMU1 = lpSensor1.getQueueSensorData();
        end
        flagIMUData = true;
    elseif (isempty(dataIMU2)) && (isempty(dataIMU1))
        flagIMUData = false;
    end
    
    if flagIMUData
        [pS1, rS1, yS1] = funcQuat2angle(dataIMU1.quat);
        [pS2, rS2, yS2] = funcQuat2angle(dataIMU2.quat);
        anglesSensors(nCount,:) = [pS1, rS1, yS1, pS2, rS2, yS2];

        linearAcc(nCount,:) = [dataIMU1.linAcc, dataIMU2.linAcc];
        posSensors(nCount,:) = funcPositionCalc(pS1, rS1, yS1, pS2, rS2, yS2);
        timeStamp(nCount,:) = [dataIMU1.timestamp dataIMU2.timestamp];
        Sample(nCount,:) = nCount;
        
        VA0(nCount,:) = readVoltage(ard, 'A0');                 % Sensor 1 connected to input A0.
        VA1(nCount,:) = readVoltage(ard, 'A1');                 % Sensor 2 connected to input A1.
        VA2(nCount,:) = readVoltage(ard, 'A2');                 % Sensor 3 connected to input A2.
        
        flagIMUData = false;
        
        disp([(nMax - nCount) dataIMU1.timestamp dataIMU2.timestamp])
        nCount = nCount +1;
    end
end
time = toc(now);
disp(time)
%% Disconnecting
disp('Disconnecting')
clear ard
if (lpSensor1.disconnect() && lpSensor2.disconnect())
    disp('Sensors disconnected')
end

disp('Storing Data to a File')
folderName = 'testsData';
[status, msg, msgID] = mkdir(folderName);
dir = [pwd, '\',folderName];
disp(dir)
S = char(datetime('now','Format','yyyy-MM-dd''T''HHmmss'));
fileName = ['manualMethod_',S,'.txt'];
fileID = fopen(fullfile(dir,fileName),'wt');
try
    fprintf(fileID,'%12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s\r\n','Sample','tStampIMU1','tStampIMU2','VA0', 'VA1', 'VA2', 'pos1X', 'pos1Y', 'pos1Z', 'pitchS1', 'rollS1', 'yawS1', 'linAccX1', 'linAccY1', 'linAccZ1', 'pos2X', 'pos2Y', 'pos2Z', 'pitchS2', 'rollS2', 'yawS2', 'linAccX2', 'linAccY2', 'linAccZ2', 'Angle');
    fprintf(fileID,'%12.0f %12.2f %12.2f %12.4f %12.4f %12.4f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.4f\r\n',[Sample, timeStamp(:,1), timeStamp(:,2), VA0, VA1, VA2, posSensors(:,1), posSensors(:,2), posSensors(:,3), anglesSensors(:,1), anglesSensors(:,2), anglesSensors(:,3), linearAcc(:,1), linearAcc(:,2), linearAcc(:,3), posSensors(:,4), posSensors(:,5), posSensors(:,6), anglesSensors(:,4), anglesSensors(:,5), anglesSensors(:,6), linearAcc(:,4), linearAcc(:,5), linearAcc(:,6), posSensors(:,7)]');
    fclose(fileID);
catch msg
    disp(msg)
end
disp('Done')
