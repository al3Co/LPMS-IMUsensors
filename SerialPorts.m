clear all
clc
fprintf('%s \n',seriallist);
qtyPorts = length(seriallist);
x = input(['Which port of the list? [1-' num2str(qtyPorts) ']. Zero to Exit: ']);
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

% /dev/cu.SLAB_USBtoUART 
% /dev/tty.SLAB_USBtoUART 
% /dev/cu.SLAB_USBtoUART3 
% /dev/tty.SLAB_USBtoUART3 