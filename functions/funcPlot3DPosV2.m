% https://www.quora.com/What-are-the-kinematics-for-a-3DOF-robot-arm
%the coloumn should contain the data in the following format:
%col   data
%1     length arm
%2     length elbow 
%3     theta L1 (angle elbow theta1)
%4     theta L1 (angle elbow theta2)
%5     theta L2 (angle wirst theta2)
function funcPlot3DPosV2(data)
%% System Configuration
clf;
theta1 = data(3);     % shoulder sensor roll or pitch or yaw depending on sensor position
theta2 = data(4);     % shoulder sensor roll or pitch or yaw depending on sensor position

theta3 = data(5);     % elbow angle

L1 = data(1);
L2 = data(2);

P12 = [0 0 -L1]';
P23 = [L2 0 0 ]';

R10 = [1 0 0;
    0 cos(theta1) -sin(theta1);
    0 sin(theta1) cos(theta1)];

R21 = [cos(theta2) 0 sin(theta2);
    0 1 0;
    -sin(theta2) 0 cos(theta2)];

R32 = [cos(theta3) 0 sin(theta3);
    0 1 0;
    -sin(theta3) 0 cos(theta3)];

R20 = R10 * R21;
R30 = R20 * R32;

P20 = R20*P12;              % first point
PEE0 = R20*P12 + R30*P23;   % second point

% manual method
Xee = -sin(theta2)*L1 +(cos(theta2)*cos(theta3) - sin(theta2)*sin(theta3))*L2;
Yee = sin(theta1)*cos(theta1)*L1 + ((sin(theta1)*sin(theta2)*cos(theta3)) + sin(theta1)*cos(theta2)*sin(theta3))*L2;
Zee = -(cos(theta1)*cos(theta2)*L1) - ((cos(theta1)*sin(theta2)*cos(theta3)) + (cos(theta1)*cos(theta2)*cos(theta3)))*L2;

%% Inverse Kinematics

THETA_1 = (pi/4) + atan2(PEE0(2), PEE0(1));
THETA_3 = (PI/4) + acos((abs(sqrt(PEE0(1)^2 + PEE0(2)^2 + PEE0(3)^2)) - L1^2 - L2^2)/ 2*(L1 * L2));
PEE1 = R10 * PEE0;
THETA_2 = atan2(PEE1(2), PEE1(1)) - THETA_3;


%% plot
grid on;
hold all
% % A1 vector
plot3([0;P20(1)],[0;P20(2)],[0;P20(3)],'r')
% % A2 vector
plot3([P20(1);PEE0(1)],[P20(2);PEE0(2)],[P20(3);PEE0(1)],'g')
% % final vector
% plot3([0;T20(1,4)],[0;T20(2,4)],[0;T20(3,4)],'b')

view(-30,30)
axis([-2 2 -2 2 -2 2])
drawnow

end


