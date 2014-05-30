% Dimensions in m
d(1) = 15.24e-3 + 0.33812 + 0.001;
d(2) = 0.52167;
d(3) = 0.26109;
d(4) = 0.13322;
d(5) = 0.190892;
a(1) = 9.82e-3;
a(2) = 7.5e-3;
a(3) = 0.051331;
a(4) = 0.787e-3;
% Symbolic variables
for i=1:6
    syms(strcat('q',num2str(i)), 'real');
    syms(strcat('d',num2str(i)), 'real');
    syms(strcat('a',num2str(i)), 'real');    
end
% Grips Slave
T0 =[   1 0 0  -a4;
        0 1 0  -a1+d3+d4+d5;
        0 0 1  d1+d2+a2+a3;
        0 0 0  1];
k = [   0  0  1;
        1  0  0;
        1  0  0;
        1  0  0;
        0  0  1;
        0  1  0];
p = [   0    0             0;
        0    0             d1;
        0    -a1           d1+d2;
        0    -a1+d3        d1+d2+a2;
        0    -a1+d3+d4     d1+d2+a2;
        -a4  -a1+d3+d4+d5  d1+d2+a2+a3];
type = [1 1 1 1 1 1]; % All are revolute joints