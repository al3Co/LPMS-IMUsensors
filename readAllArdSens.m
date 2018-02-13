%% 01.02.18 Reading 3 sensors and plot. Sensor connected to A0, A1 and A2
close all
clear
clc
%% Connection
a = arduino('COM6', 'uno');

%% Parameters
T = 100;        % number of samples to view on plot
nCount = 1;
voltageA0 = zeros(T,1);
voltageA1 = zeros(T,1);
voltageA2 = zeros(T,1);
% dataFlexSens = [maxVoltage, avgVoltage, minVoltage, voltageA0, angle]
data = [];

%% Getting data
disp('Plotting ...')
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')
set(gcf,'WindowStyle','normal');
while double(get(gcf,'CurrentCharacter'))~=27
    if nCount == T
        voltageA0 = voltageA0(2:end, :);
        voltageA1 = voltageA1(2:end, :);
        voltageA2 = voltageA2(2:end, :);
    else
        nCount = nCount + 1;
    end
    voltageA0(nCount,:) = readVoltage(a, 'A0');
    voltageA1(nCount,:) = readVoltage(a, 'A1');
    voltageA2(nCount,:) = readVoltage(a, 'A2');

    data = [voltageA0, voltageA1, voltageA2];

    plot(1:T,data)
    grid on;
    title(sprintf('A0 = %1.3f A1 = %1.3f A2 = %1.3f', voltageA0(nCount,:), voltageA1(nCount,:), voltageA2(nCount,:)))
    axis([0 T -1 5])
    drawnow
end

%% disconnect
clear a
disp('End')
