% This code shows the serial ports connected to the computer
% You choose the port you want to connect
clear all
clc
serials = seriallist;
len = length(seriallist);
for serialPort = 1:len
    fprintf('%d - %s \n', serialPort, serials(serialPort));
end
prompt = (['Select port? [' num2str(len) ' available(s)]. Zero to Exit: ']);
x = input(prompt);

if x == 0
    disp('Aborted')
    return
end

if x > len
    disp('Invalid number')
    return
end

for n = 1:len
    if n == x
        COMPort = serials(n);
    end
end
disp(COMPort)