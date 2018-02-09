function posSensors = funcPositionCalc(pitchS1, rollS1, yawS1, pitchS2, rollS2, yawS2)
%% Parameters
length1 = 1;
length2 = 1;
posIni = [0 0 0];
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
%% Return
posSensors = [xS1 yS1 zS1 xS2 yS2 zS2 angleR];
end