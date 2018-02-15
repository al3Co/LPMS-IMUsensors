function [positions, angleR] = funcPlotVector2S(angleSens, linearAcc)
clf;
% Parameters
length1 = 1;
length2 = 1;
posIni = [0 0 0];
%% Position sensor 1
rollS1 = angleSens(1); pitchS1 = angleSens(2); yawS1 = angleSens(3);
xS1 = posIni(1) + cos(yawS1)*cos(pitchS1)*length1;
yS1 = posIni(2) + sin(yawS1)*cos(pitchS1)*length1;
zS1 = posIni(3) + sin(pitchS1)*length1;

%% Position sensor 2
rollS2 = angleSens(4); pitchS2 = angleSens(5); yawS2 = angleSens(6);
xS2 = xS1 + cos(yawS2)*cos(pitchS2)*length2;
yS2 = yS1 + sin(yawS2)*cos(pitchS2)*length2;
zS2 = zS1 + sin(pitchS2)*length2;

%% Angle between two vectors
angleR = subspace([xS1;yS1;zS1],[xS2;yS2;zS2])*2;
angleD = rad2deg(angleR);

%% Plot
grid on;
hold all;
mArrow3(posIni,[xS1 yS1 zS1], 'facealpha', 0.5, 'color', 'red', 'stemWidth', 0.02);
mArrow3([xS1 yS1 zS1],[xS2 yS2 zS2], 'facealpha', 0.5, 'color', 'blue', 'stemWidth', 0.02);
ax = length1 + length2;
axis([-ax ax -ax ax -ax ax]);
xlabel('X'); ylabel('Y'); zlabel('Z');
view(-35,45)
title(sprintf('Angle: %.2f rad %.2fº', angleR, angleD))
drawnow

%% Return positions
positions = [xS1 yS1 zS1 xS2 yS2 zS2];
end
