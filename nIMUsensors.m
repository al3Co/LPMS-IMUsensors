close all
clear all
clc

% COM port cleaning...
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
date = char(datetime('now','Format','yyyy-MM-dd''T''HHmmss'));
% Parameters
COMPort = {'COM9', 'COM10', 'COM12'};
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

count = 1;
disp('Getting data')

DlgH = figure;
H = uicontrol('Style', 'PushButton', ...
                    'String', 'Stop', ...
                    'Callback', 'delete(gcbf)');
% getting data  
while (ishandle(H))
    for imu = 1:nIMUs
        lpData = lpSensor(imu).getQueueSensorData();
        % lpData = lpSensor(imu).getCurrentSensorData();
        if ~isempty(lpData)
            funcSaveIMUsData(count, imu, date, lpData);
        end
    end
    count = count + 1;
    % disp(count)
    % pause(0.001);
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
