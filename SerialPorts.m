close all
clear
clc
fprintf('%s \n',seriallist);
connectedSerials = seriallist;
x = input(['Which port of the list? [1->' num2str(length(connectedSerials)) ']. Zero to Exit: ']);
if x == 0
    return
end
COMPort = connectedSerials(x);
disp(COMPort)

% /dev/cu.SLAB_USBtoUART 
% /dev/tty.SLAB_USBtoUART 
% /dev/cu.SLAB_USBtoUART3 
% /dev/tty.SLAB_USBtoUART3 