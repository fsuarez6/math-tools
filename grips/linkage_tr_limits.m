SE = [-pi pi/6];
EL = [-55 120]*pi/180
%~ TR = [-80 30]*pi/180
for i = 1:2
    for j = 1:2
        TR(i,j) = EL(i) - SE(j) - pi/2;
        %~ EL(i,j) = TR(i) + SE(j)
    end
end
TR*180/pi
%~ EL*180/pi
