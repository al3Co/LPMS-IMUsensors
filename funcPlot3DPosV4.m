function funcPlot3DPosV4(data)
clf;

L1 = data(1);
L2 = data(2);

%% Sensor 1
theta1 = data(3);
theta2 = data(4);
theta3 = data(5);

P12 = [L1 0 0]'; % [X Y Z]

R10 = [1 0 0;
    0 cos(theta1) -sin(theta1);
    0 sin(theta1) cos(theta1)];

R21 = [cos(theta2) 0 sin(theta2);
    0 1 0;
    -sin(theta2) 0 cos(theta2)];

R32 = [cos(theta3) -sin(theta3) 0;
    sin(theta3) cos(theta3) 0
    0 0 1];

R30 = R10 * R21 * R32;
P30 = R30 * P12;        % First Point

%% Sensor 2

theta4 = data(6);
theta5 = data(7);
theta6 = data(8);

P23 = [L2 0 0]'; % [X Y Z]

R43 = [1 0 0;
    0 cos(theta4) -sin(theta4);
    0 sin(theta4) cos(theta4)];

R54 = [cos(theta5) 0 sin(theta5);
    0 1 0;
    -sin(theta5) 0 cos(theta5)];

R65 = [cos(theta6) -sin(theta6) 0;
    sin(theta6) cos(theta6) 0
    0 0 1];

R60 = R43 * R54 * R65;
P60 = R60 * P23 + P30;      % Final Point

%% Plot
grid on;
hold all
% % A1 vector
%plot3([0;P30(1)],[0;P30(2)],[0;P30(3)],'r')
mArrow3([0 0 0],[P30(1) P30(2) P30(3)], 'facealpha', 0.5, 'color', 'red', 'stemWidth', 0.02); 

% % A2 vector
%plot3([P30(1);P60(1)],[P30(2);P60(2)],[P30(3);P60(1)],'g')
mArrow3([P30(1) P30(2) P30(3)],[P60(1) P60(2) P60(3)], 'facealpha', 0.5, 'color', 'blue', 'stemWidth', 0.02);

% % final vector
%plot3([0;PEE0(1)],[0;PEE0(2)],[0;PEE0(1)],'b')

xlabel('X')
ylabel('Y')
zlabel('Z')
light('Position',[-1 0 0],'Style','local')
view(3)
axis([-2 2 -2 2 -2 2])
drawnow
end
