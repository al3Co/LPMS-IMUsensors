function funcSaveIMUsData(count, num, date, lpData)
fileName = ['dataIMU',num2str(num),'_', date,'.txt'];
if count <= 1
    fileID = fopen(fileName, 'w+');
    fprintf(fileID,'%12s %12s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s\r\n',...
        'TimeStamp','Sample',...
        'gyrX','gyrY','gyrZ','accX','accY','accZ','magX','magY','magZ',...
        'quat1','quat2','quat2','quat2','eulerX','eulerY','eulerZ',...
        'linAccX','linAccY','linAccZ');
else
    count = count - 1;
    fileID = fopen(fileName, 'a');
    fprintf(fileID,'%12.2f %12.0f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f\r\n',...
        lpData.timestamp, count,...
        lpData.gyr, lpData.acc, lpData.mag,...
        lpData.quat, lpData.euler, lpData.linAcc);
end
fclose(fileID);
end