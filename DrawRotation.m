function DrawRotation (x, y, z)
% Como ejemplo donde  R = rpy2r(vicon_angle.roll(i),vicon_angle.pitch(i),vicon_angle.yaw(i));
length = 0.1;

%R = rpy2r(-20,40,-10);
R = rpy2r(x, y, z);
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
p1=plot3(tx_vec(:,1), tx_vec(:,2), tx_vec(:,3));
set(p1,'Color','Green','LineWidth',1);
p1=plot3(ty_vec(:,1), ty_vec(:,2), ty_vec(:,3));
set(p1,'Color','Blue','LineWidth',1);
p1=plot3(tz_vec(:,1), tz_vec(:,2), tz_vec(:,3));
set(p1,'Color','Red','LineWidth',1);
end

