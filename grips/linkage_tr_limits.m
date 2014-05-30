SE = [-pi pi/6];
EL = [42.93 241]*pi/180
for i = 1:2
    for j = 1:2
        TR(i,j) = EL(i) - SE(j) - pi;
    end
end
TR*180/pi