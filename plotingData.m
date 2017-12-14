function plotingData(ts, accS1, accS2)
f = figure;
p = uipanel('Parent',f,'BorderType','none');
p.Title = 'IMU Sensors';
p.TitlePosition = 'centertop';
p.FontSize = 12;
p.FontWeight = 'bold';

subplot(1,2,1,'Parent',p)
%x = linspace(0,20,50);
%y1 = sin(2*x);
plot(ts-ts(1),accS1)
title('Sensor 1')

subplot(1,2,2,'Parent',p)
%y2 = rand(50,1);
plot(ts-ts(1),accS2)
title('Sensor 2')
end
