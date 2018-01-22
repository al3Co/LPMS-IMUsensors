function funcDrawRotation (yaw, pitch, roll)
% Example:  R = rpy2r(vicon_angle.roll(i),vicon_angle.pitch(i),vicon_angle.yaw(i));
clf;

length = 1.0;
az=15;
el=64;
view(az,el);
grid on;
xlabel('x', 'fontsize',16);
ylabel('y', 'fontsize',16);
zlabel('z', 'fontsize',16);
%h_legend=legend('X','Y','Z');

R = rpy2r(roll, pitch, yaw);
% generate axis vectors
tx = [length,0.0,0.0];
ty = [0.0,length,0.0];
tz = [0.0,0.0,length];
% Rotate it by R
t_x_new = R*tx';
t_y_new = R*ty';
t_z_new = R*tz';

% translate vectors to camera position. Make the vectors for plotting

% donde pose.x = posición en X etc...
%origin=[vicon_pose.x(i),vicon_pose.y(i),vicon_pose.z(i)];
origin=[0,0,0];
tx_vec(1,1:3) = origin;
tx_vec(2,:) = t_x_new + origin';
ty_vec(1,1:3) = origin;
ty_vec(2,:) = t_y_new + origin';
tz_vec(1,1:3) = origin;
tz_vec(2,:) = t_z_new + origin';
hold on;

% Plot the direction vectors at the point
%Initial
vX=[1 0 0];
vY=[0 1 0];
vZ=[0 0 1];
vX=[vX;origin];
vY=[vY;origin];
vZ=[vZ;origin];
plot3(vX(:,1),vX(:,2),vX(:,3),'g')
plot3(vY(:,1),vY(:,2),vY(:,3),'b')
plot3(vZ(:,1),vZ(:,2),vZ(:,3),'r')
%Actual
p1=plot3(tx_vec(:,1), tx_vec(:,2), tx_vec(:,3));
set(p1,'Color','Green','LineWidth',1);
p1=plot3(0, 1, 1);
set(p1,'Color','Green','LineWidth',3);
p1=plot3(ty_vec(:,1), ty_vec(:,2), ty_vec(:,3));
set(p1,'Color','Blue','LineWidth',1);
p1=plot3(tz_vec(:,1), tz_vec(:,2), tz_vec(:,3));
set(p1,'Color','Red','LineWidth',1);
grid on;
drawnow

end

