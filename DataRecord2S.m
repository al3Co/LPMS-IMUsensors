close all
clear
clc

%% Parameters
nData = 500;    % number of samples to record (seconds / 100)
nCount = 1;     % starting number
fprintf('Script to record LPMS sensor data with %d data range.\n', nData);

%% TODO: code to Serial port selection
COMPort = {'/dev/tty.SLAB_USBtoUART', '/dev/tty.SLAB_USBtoUART4'};
%COMPort = {'/dev/tty.SLAB_USBtoUART'};
len = length(COMPort);

%% Comunication parameters      
baudrate = 921600;           % rate at which information is transferred
for n = 1:len
    lpSensor(n) = lpms1();          % function lpms API sensor given by LPMS
end

%% Variables used
cancel = true;          % Cancel button waitbar
s1Connected = [0, 0];   % Variables for know state of connection sensor's
ts = zeros(nData,1);    % TimeSample
sensorData = zeros(1, len);    %


%% Storages
accDataS1 = zeros(nData,3); % variable for 
accDataS2 = zeros(nData,3);
quatData = zeros(nData,4);

%% Connection
for n = 1:len
    disp('Connecting to:')
    disp(COMPort(n));
    if ( ~lpSensor(n).connect(COMPort(n), baudrate) )
        disp('Sensor not connected');
        s1Connected(n) = 1;
    end
end

for n = s1Connected
    if n == 1
        for m = 1:len
            if (lpSensor(m).disconnect())
                disp('sensor disconnected')
            end
        end
        disp('Exit')
        return 
    end
end

%% Setting streaming mode
for n = 1:len
    disp('Setting mode ...')
    lpSensor(n).setStreamingMode();
end

%% Getting sync data
disp('Getting data ...')
while nCount <= nData
    for n = 1:len
        if n == 1
            dS1 = lpSensor(n).getQueueSensorData();
            if (~isempty(dS1))
                accDataS1(nCount,:) = dS1.acc;
            end
        else
            dS2 = lpSensor(n).getQueueSensorData();
            if (~isempty(dS2))
                accDataS2(nCount,:) = dS2.acc;
            end
        end
    end
    if (~isempty(dS1) && ~isempty(dS2))
        nCount=nCount + 1;
    end
end
fprintf('Getting data: %d done.\n', (nCount - 1));

%% Disconnect sensors
for n = 1:len
    if (lpSensor(n).disconnect())
        disp('sensor disconnected')
    end
end
