function funcPlotVector(pitch, roll, yaw)
clf;

L1 = 1;

%% Sensor 1
P12 = [0 -L1 0]'; % [X Y Z]

Rx = rotx(roll);
Ry = roty(pitch);
Rz = rotz(yaw);

R30 = Rx * Ry * Rz;
% R30 = Rz * Ry * Rx;
P30 = R30 * P12;        % First Point

% % Sensor 2
% 
% R60 = R43 * R54 * R65;
% P60 = R60 * P23 + P30;      % Final Point

%% Plot
grid on;
hold all;
subplot(2,2,1);
%plot3([0;P30(1)],[0;P30(2)],[0;P30(3)],'r');
mArrow3([0 0 0],[P30(1) P30(2) P30(3)], 'facealpha', 0.5, 'color', 'red', 'stemWidth', 0.02);
%mArrow3([P30(1) P30(2) P30(3)],[P60(1) P60(2) P60(3)], 'facealpha', 0.5, 'color', 'blue', 'stemWidth', 0.02);
axis([-2 2 -2 2 -2 2]);
xlabel('X')
ylabel('Y')
zlabel('Z')
%set(gca, 'CameraPosition', [6 2 3]);
view(3);
title('3D');

subplot(2,2,2);
hold all;
plot([0;P30(1)],[0;P30(2)],'r');
%plot([P30(1);P60(1)],[P30(2);P60(2)],'b')
axis([-1 1 -1 1])
view(0,90);
xlabel('X') % x-axis label
ylabel('Y') % y-axis label
title(sprintf('Yaw: %.3f rad', (yaw)));

subplot(2,2,3);
hold all;
plot([0;P30(1)],[0;P30(3)],'r');
%plot([P30(1);P60(1)],[P30(3);P60(3)],'b')
axis([-1 1 -1 1])
view(0,0);
xlabel('X') % x-axis label
ylabel('Z') % y-axis label
title(sprintf('Roll: %.3f rad', (roll)));

subplot(2,2,4);
hold all;
plot([0;P30(2)],[0;P30(3)],'r');
%plot([P30(2);P60(2)],[P30(3);P60(3)],'b')
axis([-1 1 -1 1])
view(90,0);
xlabel('Y') % x-axis label
ylabel('Z') % y-axis label
title(sprintf('Pitch: %.3f rad', (pitch)));

% % A2 vector
%plot3([P30(1);P60(1)],[P30(2);P60(2)],[P30(3);P60(3)],'g')
% mArrow3([P30(1) P30(2) P30(3)],[P60(1) P60(2) P60(3)], 'facealpha', 0.5, 'color', 'blue', 'stemWidth', 0.02);

% % final vector
%plot3([0;P60(1)],[0;P60(2)],[0;P60(1)],'b')

drawnow
end
