close all
clear all
clc

% COM port cleaning
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

% Parameters
COMPort = {'/dev/ttyUSB0', '/dev/ttyUSB1'};
[~,nIMUs] = size(COMPort);

T = 400;
nCount = 1;
baudrate = 921600;
accData = zeros(T,3);

% create nIMUs instances
for imu = 1:nIMUs
    lpSensor(imu) = lpms();
end


% Connect to sensor
for imu = 1:nIMUs
    if ( ~lpSensor(imu).connect(COMPort(imu), baudrate) )
        return 
    end
end

% Set streaming mode
for imu = 1:nIMUs
    lpSensor(imu).setStreamingMode();
end

% getting data
global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
gcf
set(gcf, 'KeyPressFcn', @myKeyPressFcn)
while ~KEY_IS_PRESSED
    for imu = 1:nIMUs
        lpData(imu) = lpSensor(imu).getQueueSensorData();
        while (isempty(lpData(imu)))
            lpData(imu) = lpSensor(imu).getQueueSensorData();
        end
    end
    
    % do something with data
    
    drawnow
end
disp('loop ended')
close gcf

% disconnecting
for imu = 1:nIMUs
    if (lpSensor(imu).disconnect())
        disp('sensor disconnected')
    end
end


% press any key function
function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed')
end