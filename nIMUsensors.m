close all
clear all
clc

% COM port cleaning
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
date = char(datetime('now','Format','yyyy-MM-dd''T''HHmmss'));
% Parameters
COMPort = {'COM9', 'COM10'};
[~,nIMUs] = size(COMPort);

nCount = 1;
baudrate = 921600;

% create nIMUs instances
for imu = 1:nIMUs
    lpSensor(imu) = lpms();
end


% Connect to sensor
disp('Connecting')
for imu = 1:nIMUs
    if ( ~lpSensor(imu).connect(COMPort(imu), baudrate) )
        return 
    end
end

% Set streaming mode
for imu = 1:nIMUs
    lpSensor(imu).setStreamingMode();
end

disp('Getting data, Press any key to stop')
% getting data
global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
gcf;
set(gcf, 'KeyPressFcn', @myKeyPressFcn);
count = 1;
while ~KEY_IS_PRESSED
    for imu = 1:nIMUs
        lpData = lpSensor(imu).getQueueSensorData();
        if ~isempty(lpData)
            funcSaveIMUsData(count, imu, date, lpData);
        end
    end
    count = count + 1;
    drawnow
end
disp('loop ended')
close gcf
close all

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