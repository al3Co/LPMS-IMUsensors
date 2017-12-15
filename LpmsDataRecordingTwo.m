close all
clear
clc

%% Parameters
nData = 50;    % number of samples to record (seconds / 100)
nCount = 1;     % starting number
fprintf('Script to record LPMS sensor data with %d data range.\n', nData);

%% code to Serial port selection TODO
COMPortS1 = '/dev/tty.SLAB_USBtoUART';
COMPortS2 = '/dev/tty.SLAB_USBtoUART2';

%% Comunication parameters      
baudrate = 921600;             % rate at which information is transferred
lpSensorS1 = lpms1();          % function lpms API sensor 1 given by LPMS
lpSensorS2 = lpms2();          % function lpms API sensor 2 given by LPMS

cancel = true;
ts = zeros(nData,1);

%% Variables for data Storage
accDataS1 = zeros(nData,3);
accDataS2 = zeros(nData,3);
%quatData = zeros(nData,4);

%% Connect to sensor (TODO: function to know if connected each sensor)
disp('Connecting sensor 1 ...');
if ( ~lpSensorS1.connect(COMPortS1, baudrate) )
    disp('Sensor 1 not connected')
    return 
end
disp('Sensor 1 connected');

disp('Connecting sensor 2 ...');
if ( ~lpSensorS2.connect(COMPortS2, baudrate) )
    disp('Sensor 2 not connected')
    return 
end
disp('Sensor 2 connected');

%% Set streaming mode
disp('Setting sensors');
lpSensorS1.setStreamingMode();
lpSensorS2.setStreamingMode();
%% Setting Wait Bar
h = waitbar(0,'1','Name','Getting Data...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)

%% Reading Data
disp('Accumulating sensors data')
while nCount <= nData
    % Check for Cancel button press
    if getappdata(h,'canceling')
        cancel = false;
        break
    end
    d1 = lpSensorS1.getQueueSensorData();
    d2 = lpSensorS2.getQueueSensorData();
    if (~isempty(d1) && ~isempty(d2))
        ts(nCount) = d1.timestamp;
        accDataS1(nCount,:) = d1.acc;
        accDataS2(nCount,:) = d2.acc;
        %quatData(nCount,:) = d.quat;
        % Report current estimate in the waitbar's message field
        waitbar(nCount/nData,h,sprintf('Data: %d',nCount))
        nCount=nCount + 1;
    end
end
disp('Done')
delete(h)

%% Disconnecting sensors
disp('Disconnecting sensors ...')
if (lpSensorS1.disconnect())
    disp('Sensor 1 disconnected')
end
if (lpSensorS2.disconnect())
    disp('Sensor 2 disconnected')
end

%% Plot Data
if cancel
    disp('Plotting')
    plotingData(ts, accDataS1, accDataS2);
else
    disp('Process Canceled');
end

% plot(ts-ts(1), accDataS1);
% xlabel('timestamp(s)');
% ylabel('Acc(g)');
% grid on
