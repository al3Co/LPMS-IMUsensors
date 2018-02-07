function funcPlotVectorV2(pitch, roll, yaw)
clf;

L1 = 0.5;

%% Sensor 1

x = cos(yaw)*cos(pitch);
y = sin(yaw)*cos(pitch);
z = sin(pitch);

pt = [0 0 0];
h = quiver3(pt(1),pt(2),pt(3), x, y, z, L1);
view(-35,45)
xlim([-1 1])
ylim([-1 1])
zlim([-1 1])

drawnow
end
