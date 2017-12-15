function y = COMPort()
if ismac
    COMPort = '/dev/tty.SLAB_USBtoUART';
elseif ispc
    COMPort = 'COM3';
elseif isunix
    COMPort = '/dev/tty.SLAB_USBtoUART';
else
    disp('Platform not supported')
    return
end
y = COMPort; 
end