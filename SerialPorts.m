clear all
clc
fprintf('%s \n',seriallist);
prompt = 'Which port? [1-16] Zero to Exit: ';
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