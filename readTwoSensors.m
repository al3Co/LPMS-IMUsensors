%% This is a script that reads data from a single sensor and stores it in a variable
close all
clear
clc
t = cputime;

%% Parameters
nData = 50;     % number of samples to record (seconds / 100)
nCount = 0;     % starting number
fprintf('Script to initialize sensor with %d data range.\n', nData);

%% Code to Serial port selection
COMPort1 = 'COM3';
COMPort2 = 'COM4';

%% Comunication parameters
baudrate = 921600;          % rate at which information is transferred
lpSensor1 = lpms();          % function lpms API sensor given by LPMS
lpSensor2 = lpms1();

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
% write data to File
fileS1 = fopen('DataS1.txt','w');
fprintf(fileS1,'%12s %12s %12s %12s\r\n','timestamp','gyrX', 'gyrY', 'gyrZ');

fileS2 = fopen('DataS2.txt','w');
fprintf(fileS2,'%12s %12s %12s %12s\r\n','timestamp','gyrX', 'gyrY', 'gyrZ');

while nCount <= nData
    if lpSensor1.hasSensorData()
        dS1 = lpSensor1.getQueueSensorData();
        disp(dS1)
        dataS1 = [dS1.timestamp dS1.gyr];
        fprintf(fileS1,'%12.2f %12.4f %12.4f %12.4f\r\n',dataS1);
        nCount = nCount + 1;
    end
    
    if lpSensor2.hasSensorData()
        dS2 = lpSensor2.getQueueSensorData();
        disp(dS2)
        dataS2 = [dS2.timestamp dS2.gyr];
        fprintf(fileS2,'%12.2f %12.4f %12.4f %12.4f\r\n',dataS2);
    end
end
fclose(fileS1);
fclose(fileS2);
%% Print information from reading

disp('Done')
if (lpSensor1.disconnect())
    disp('Sensor 1 disconnected')
end

if (lpSensor2.disconnect())
    disp('Sensor 2 disconnected')
end
timeInterval = cputime - t;
fprintf('Total Time: %f.\n', timeInterval);
