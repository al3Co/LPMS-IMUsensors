close all
clear
clc
t = cputime;

%% Parameters
nData = 1e2;     % number of samples to record (seconds / 100)
nCount = 1;      % starting number
fprintf('Script to initialize sensor with %d data range.\n', nData);

%% Code to Serial port selection
COMPort1 = 'COM3';

%% Comunication parameters
baudrate = 921600;          % rate at which information is transferred
lpSensor = lpms();          % function lpms sensor given by LPMS

%% Data saving
linAccData = [];

%% Connect to sensor
if ( ~lpSensor.connect(COMPort1, baudrate) )
    disp('sensor not connected')
    return 
end
disp('Sensor connected')

%% Setting streaming mode
disp('Setting mode ...')
lpSensor.setStreamingMode();

%% Loop Plot

L1 = 1;
L2 = 2;

disp('Plotting ...')
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')
set(gcf,'WindowStyle','normal');
while double(get(gcf,'CurrentCharacter'))~=27
    %d = lpSensor.getCurrentSensorData();
    d = lpSensor.getQueueSensorData();
    if (~isempty(d))
        theta_Acc = d.acc;
        theta_Mag = d.mag;
        
        % Sacar la función de graficar de la func del cálculo
        [X, Y, Z] = funcCalcPosition(theta_Acc, theta_Mag);
        
    end
    
end
disp('End');

if (lpSensor.disconnect())
    disp('sensor disconnected')
end
