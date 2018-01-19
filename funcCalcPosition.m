% (19-01-2018) function to integrate acceleration to ver and pos
%the coloumn should contain the data in the following format:
%col   data
%1     actual X lineal Accel 
%2     actual Y lineal Accel 
%3     actual Z lineal Accel
%col   time
%1     timestamp
%col   pastData
%1     past X lineal Accel 
%2     past Y lineal Accel 
%3     past Z lineal Accel

function [despX despY despZ] = funcCalcPosition(data, time, pastData)

disp(data)

vX = pastData(1) + data(1) * time;
dX = 


despX = data(1);
despY = data(2);
despZ = data(3);
end