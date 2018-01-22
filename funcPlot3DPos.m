function funcPlot3DPos(data)


clf;

L1 = data(1);
L2 = data(2);
theta1 = data(3);
theta2 = data(4);

theta3 = data(5);

X_1 = L1*cos(theta1);
Y_1 = L1*sin(theta1);
Z_1 = L1*cos(theta2);


Xee = -sin(theta2)*L1 +(cos(theta2)*cos(theta3) - sin(theta2)*sin(theta3))*L2;
Yee = sin(theta1)*cos(theta1)*L1 + ((sin(theta1)*sin(theta2)*cos(theta3)) + sin(theta1)*cos(theta2)*sin(theta3))*L2;
Zee = -cos(theta1)*cos(2)*L1 - ((cos(theta1)*sin(theta2)*cos(theta3)) + cos(theta1)*cos(theta2)*cos(theta3))*L2;
% % for 3D plot:
grid on;
hold all
% % A1 vector
plot3([0;X_1],[0;Y_1],[0;Z_1],'r')
% % A2 vector
plot3([X_1;Xee],[Y_1;Yee],[Z_1;Zee],'g')
% % final vector
% plot3([0;T20(1,4)],[0;T20(2,4)],[0;T20(3,4)],'b')

view(-18,30)
axis([-2 2 -2 2 -2 2])
drawnow

end
