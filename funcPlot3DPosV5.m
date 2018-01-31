function funcPlot3DPosV5(data)
clf;

L1 = data(1);
L2 = data(2);

%% Sensor 1
theta1 = data(3);
theta2 = data(4);
theta3 = data(5);

P12 = [0 L1 0]'; % [X Y Z]

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

% Sensor 2

theta4 = data(6);
theta5 = data(7);
theta6 = data(8);

P23 = [0 L2 0]'; % [X Y Z]

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
hold all;
subplot(2,2,1);
%plot3([0;P30(1)],[0;P30(2)],[0;P30(3)],'r');
mArrow3([0 0 0],[P30(1) P30(2) P30(3)], 'facealpha', 0.5, 'color', 'red', 'stemWidth', 0.02);
mArrow3([P30(1) P30(2) P30(3)],[P60(1) P60(2) P60(3)], 'facealpha', 0.5, 'color', 'blue', 'stemWidth', 0.02);
axis([-2 2 -2 2 -2 2]);
xlabel('X')
ylabel('Y')
zlabel('Z')
set(gca, 'CameraPosition', [6 2 3]);
view(3);
title('3D');

subplot(2,2,2);
hold all;
plot([0;P30(1)],[0;P30(2)],'r');
plot([P30(1);P60(1)],[P30(2);P60(2)],'b')
axis([-2 2 -2 2])
view(0,90);
title('XY');

subplot(2,2,3);
hold all;
plot([0;P30(1)],[0;P30(3)],'r');
plot([P30(1);P60(1)],[P30(3);P60(3)],'b')
axis([-2 2 -2 2])
view(0,0);
title('XZ');

subplot(2,2,4);
hold all;
plot([0;P30(2)],[0;P30(3)],'r');
plot([P30(2);P60(2)],[P30(3);P60(3)],'b')
axis([-2 2 -2 2])
view(90,0);
title('YZ');

% % A2 vector
%plot3([P30(1);P60(1)],[P30(2);P60(2)],[P30(3);P60(3)],'g')
% mArrow3([P30(1) P30(2) P30(3)],[P60(1) P60(2) P60(3)], 'facealpha', 0.5, 'color', 'blue', 'stemWidth', 0.02);

% % final vector
%plot3([0;P60(1)],[0;P60(2)],[0;P60(1)],'b')

drawnow
end
