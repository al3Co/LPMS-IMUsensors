% (18-01-2018) This calculate the x and y from IMU sensor as elbow-arm given the angles
%the coloumn should contain the data in the following format:
%col   data
%1     length arm
%2     length elbow 
%3     theta a1 (angle theta1)
%4     theta a2 (angle theta2)

function funcDrawSensor(data)

clf;

a1 = data(1);
a2 = data(2);
theta1 = data(3);
theta2 = data(4);


A1 = [cos(theta1) -sin(theta1) 0 a1*cos(theta1);
    sin(theta1) cos(theta1) 0 a1*sin(theta1);
    0 0 1 0;
    0 0 0 1];

A2 = [cos(theta2) -sin(theta2) 0 a2*cos(theta2);
    sin(theta2) cos(theta2) 0 a2*sin(theta2);
    0 0 1 0;
    0 0 0 1];

T10 = A1;
T20 = A1*A2;

xS1 = (0 + T10(1,4))/2;
yS1 = (0 + T10(2,4))/2;
circ1Pos = [(xS1) (yS1) (0.1*a1) (0.1*a1)]; %[x y w h]

xS2 = (T10(1,4) + T20(1,4))/2;
yS2 = (T10(2,4) + T20(2,4))/2;
circ2Pos = [(xS2) (yS2) (0.1*a2) (0.1*a2)]; %[x y w h]

grid on;
hold on;
rectangle('Position',circ1Pos,'Curvature',[1 1],'FaceColor',[1 0 0])
rectangle('Position',circ2Pos,'Curvature',[1 1],'FaceColor',[0 1 0])
plot([0;T10(1,4)],[0;T10(2,4)],'r')
plot([T10(1,4);T20(1,4)],[T10(2,4);T20(2,4)],'g')
% axis tight
% axis equal
axis([(-2*a1) (2*a1) (-2*a2) (2*a2)])

% % for 3D plot:
% % A1 vector
% plot3([0;A1(1,4)],[0;A1(2,4)],[0;A1(3,4)],'r')
% % A2 vector
% plot3([A1(1,4);A2(1,4)],[A1(2,4);A2(2,4)],[A1(3,4);A2(3,4)],'g')
% % final vector
% plot3([0;T20(1,4)],[0;T20(2,4)],[0;T20(3,4)],'b')

drawnow

end
