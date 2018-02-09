function funcStoreDataANN(voltageArd, dataIMU1, dataIMU2, nCount, fileID)
% Parameters
length1 = 1;
length2 = 1;
posIni = [0 0 0];

[pitchS1, rollS1, yawS1] = quat2angle(dataIMU1.quat, 'YXZ');     % convert quaternions to angles roll, pitch and yaw
[pitchS2, rollS2, yawS2] = quat2angle(dataIMU2.quat, 'YXZ');     % convert quaternions to angles roll, pitch and yaw

linearAcc = [dataIMU1.linAcc, dataIMU2.linAcc];


%% Position sensor 1
xS1 = posIni(1) + cos(yawS1)*cos(pitchS1)*length1;
yS1 = posIni(2) + sin(yawS1)*cos(pitchS1)*length1;
zS1 = posIni(3) + sin(pitchS1)*length1;

%% Position sensor 2
xS2 = xS1 + cos(yawS2)*cos(pitchS2)*length2;
yS2 = yS1 + sin(yawS2)*cos(pitchS2)*length2;
zS2 = zS1 + sin(pitchS2)*length2;

%% Angle between two vectors
angleR = subspace([xS1;yS1;zS1],[xS2;yS2;zS2])*2;


%% Create file and Save data
% angleR voltageArd(1) voltageArd(2) ... TODO

if nCount == 1
    fprintf(fileID,'%12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s\r\n','timestamp','VA0', 'VA1', 'VA2', 'pos1X', 'pos1Y', 'pos1Z', 'pitchS1', 'rollS1', 'yawS1', 'linAccX1', 'linAccY1', 'linAccZ1', 'pos2X', 'pos2Y', 'pos2Z', 'pitchS2', 'rollS2', 'yawS2', 'linAccX2', 'linAccY2', 'linAccZ2', 'Angle');
    fprintf(fileID,'%12.0f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f\r\n',nCount, voltageArd(1), voltageArd(2), voltageArd(3), xS1, yS1, zS1, pitchS1, rollS1, yawS1, linearAcc(1), linearAcc(2), linearAcc(3), xS2, yS2, zS2, pitchS2, rollS2, yawS2, linearAcc(4), linearAcc(5), linearAcc(6), angleR);
else
    fprintf(fileID,'%12.0f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f %12.4f\r\n',nCount, voltageArd(1), voltageArd(2), voltageArd(3), xS1, yS1, zS1, pitchS1, rollS1, yawS1, linearAcc(1), linearAcc(2), linearAcc(3), xS2, yS2, zS2, pitchS2, rollS2, yawS2, linearAcc(4), linearAcc(5), linearAcc(6), angleR);
end

%% Plot
angleD = rad2deg(angleR);

grid on;
hold all;
mArrow3(posIni,[xS1 yS1 zS1], 'facealpha', 0.5, 'color', 'red', 'stemWidth', 0.02);
mArrow3([xS1 yS1 zS1],[xS2 yS2 zS2], 'facealpha', 0.5, 'color', 'blue', 'stemWidth', 0.02);
ax = length1 + length2;
axis([-ax ax -ax ax -ax ax]);
xlabel('X'); ylabel('Y'); zlabel('Z');
view(-35,45)
title(sprintf('Angle: %.2f rad %.2fº Sample: %d', angleR, angleD, nCount))
drawnow

end