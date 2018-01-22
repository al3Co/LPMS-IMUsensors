% (19-01-2018) function to find position
%the coloumn should contain the data in the following format:
%col   theta_Acc
%1     actual X acc 
%2     actual Y acc
%3     actual Z acc
%col   theta_Mag
%1     actual X Mag
%2     actual Y Mag
%3     actual Z Mag

function [X, Y, Z] = funcCalcPosition(theta_Acc, theta_Mag)
clf;

theta_i = theta_Acc(1);
theta_r = asin(sin(theta_Acc(3))/cos(theta_Acc(1)));
theta_h = theta_Mag(1)/cos(theta_Acc(1));

L1 = 1;

X = (cos(theta_i)*cos(theta_h) - sin(theta_i)*sin(theta_r)*sin(theta_h)) * L1;
Y = (sin(theta_i)*cos(theta_h) + cos(theta_i)*sin(theta_r)*sin(theta_h)) * L1;
Z = -cos(theta_r)*sin(theta_h) * L1;

grid on;
hold on;

plot3([0;X],[0;Y],[0;Z],'r')

drawnow

end