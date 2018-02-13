function [r1,r2,r3] = funcQuat2angle( q )



qin = quatnormalize( q );


[r1,r2,r3] = threeaxisrot( 2.*(qin(:,2).*qin(:,4) + qin(:,1).*qin(:,3)), ...
                           qin(:,1).^2 - qin(:,2).^2 - qin(:,3).^2 + qin(:,4).^2, ...
                          -2.*(qin(:,3).*qin(:,4) - qin(:,1).*qin(:,2)), ...
                           2.*(qin(:,2).*qin(:,3) + qin(:,1).*qin(:,4)), ...
                           qin(:,1).^2 - qin(:,2).^2 + qin(:,3).^2 - qin(:,4).^2); 

function [r1,r2,r3] = threeaxisrot(r11, r12, r21, r31, r32)
    % find angles for rotations about X, Y, and Z axes
    r1 = atan2( r11, r12 );
    r2 = asin( r21 );
    r3 = atan2( r31, r32 );
end

end
