% This code shows the serial ports connected to the computer
% You choose the port you want to connect
clear all
clc
fprintf('%s \n',seriallist);
prompt = 'Select port? [1-16] Zero to Exit: ';
x = input(prompt);
if x == 0
    return
end
sCount = 1;
for n = seriallist
    if sCount == x
        COMPort = n;
    end
    sCount = sCount + 1;
end
disp(COMPort)