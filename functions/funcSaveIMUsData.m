function funcSaveIMUsData(num, data)
    
filename = "dataIMU"+ num + ".csv";
fileID = fopen(filename,'a');
fprintf(fileID,'%f %f\n',data');

end