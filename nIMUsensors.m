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

% disconnecting
for imu = 1:nIMUs
    if (lpSensor(imu).disconnect())
        disp('sensor disconnected')
    end
end