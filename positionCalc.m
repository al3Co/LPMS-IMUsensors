close all
clear
clc
t = cputime;

%% Parameters
T = 400;        % number of samples to view on plot 
nCount = 1;     % starting number
fprintf('Script to real time plot position with %d data width \n', T);

%% Code to Serial port selection
COMPort1 = 'COM3';

%% Comunication parameters
baudrate = 921600;          % rate at which information is transferred
lpSensor = lpms();          % function lpms sensor given by LPMS

%% Data saving
linAccData = [];

%% Connect to sensor
if ( ~lpSensor.connect(COMPort, baudrate) )
    disp('sensor not connected')
    return 
end
disp('Sensor connected')

%% Setting streaming mode
disp('Setting mode ...')
lpSensor.setStreamingMode();

vX = 0;
dposX = 0;

%% Loop Plot

while true
    %d = lpSensor.getCurrentSensorData();
    d = lpSensor.getQueueSensorData();
    if (~isempty(d))
        linAcc_now = d.linAcc;
        vX = linAcc_now(1) +(abs(linAcc_now(1) - vX)/2)*(d.timestamp);
        posX = 
        disp(vX)
    end
end

if (lpSensor.disconnect())
    disp('sensor disconnected')
end
