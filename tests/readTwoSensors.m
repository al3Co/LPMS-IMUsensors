%% This script reads data from two sensors and stores it in a file
close all
clear
clc
t = cputime;

%% Parameters
nData = 1e8;    % number of iteration cycles
nCountS1 = 1;   % sensor data counter
nCountS2 = 1;   % sensor data counter
counter = 0;    % counter cycle
dataS1 = [];    % storage variable
dataS2 = [];    % storage variable
fprintf('Script to initialize sensor with %d data range.\n', nData);

%% Code to Serial port selection
COMPort1 = 'COM3';
COMPort2 = 'COM4';

%% Comunication parameters
baudrate = 921600;      % rate at which information is transferred
lpSensor1 = lpms();     % function lpms API sensor given by LPMS developer
lpSensor2 = lpms();     % function lpms API sensor given by LPMS developer


%% Connect to sensor

disp('Connecting to sensor 1 ...')
if ( ~lpSensor1.connect(COMPort1, baudrate) )
    disp('Sensor 1 not connected')
    return 
end
disp('Sensor 1 connected')

disp('Connecting to sensor 2 ...')
if ( ~lpSensor2.connect(COMPort2, baudrate) )
    disp('Sensor 2 not connected')
    return
end
disp('Sensor 2 connected')

%% Setting streaming mode
disp('Setting mode sensor 1 ...')
lpSensor1.setStreamingMode();

disp('Setting mode sensor 2 ...')
lpSensor2.setStreamingMode();

%% Reading Data
disp('Accumulating data...')

%% Prepare File to save data
fileS1 = fopen('DataS1.txt','w');
fprintf(fileS1,'%12s %12s %12s %12s\r\n','timestamp','gyrX', 'gyrY', 'gyrZ');

fileS2 = fopen('DataS2.txt','w');
fprintf(fileS2,'%12s %12s %12s %12s\r\n','timestamp','gyrX', 'gyrY', 'gyrZ');

%% Reading data from sensors

while (counter < nData)
    dS1 = lpSensor1.getQueueSensorData();
    dS2 = lpSensor2.getQueueSensorData();
    
    if  ~isempty(dS1)
        disp(dS1)
        tmpData = [dS1.timestamp dS1.gyr];
        dataS1(nCountS1,:) = tmpData;
        fprintf(fileS1,'%12.2f %12.4f %12.4f %12.4f\r\n', tmpData);
        nCountS1 = nCountS1 + 1;
    end
    
    if  ~isempty(dS2)
        disp(dS2)
        tmpData = [dS2.timestamp dS2.gyr];
        dataS2(nCountS2,:) = tmpData;
        fprintf(fileS2,'%12.2f %12.4f %12.4f %12.4f\r\n', tmpData);
        nCountS2 = nCountS2 + 1;
    end
    counter = counter + 1;
end
fclose(fileS1);
fclose(fileS2);

%% Disconnecting Sensors
disp('Disconnecting')
if (lpSensor1.disconnect())
    disp('Sensor 1 disconnected')
end

if (lpSensor2.disconnect())
    disp('Sensor 2 disconnected')
end
timeInterval = cputime - t;
fprintf('Total Time: %f.\n', timeInterval);

