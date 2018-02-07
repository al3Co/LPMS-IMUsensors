function COM = funcCOMPort()
%fprintf('%s \n',seriallist);
connectedSerials = seriallist;
if ismac || isunix
    pattern = '/dev/tty.SLAB_USBtoUART';
    TF = contains(connectedSerials,pattern);
    for n = 1: length(connectedSerials)
        if TF(n) == 0
            if length(connectedSerials) == 1
                connectedSerials = [];
            else
                connectedSerials(n) = '';
            end
            
        end
    end
    connectedSerials(strcmp('',connectedSerials)) = [];
    COMPort = connectedSerials;
elseif ispc
    %COMPort = connectedSerials;
    COMPort = "COM3";
else
    disp('Platform not supported')
    return
end
COM = COMPort;
end