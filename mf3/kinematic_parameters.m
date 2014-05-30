% Dimensions in mm
d(1) = 108.5+13.2;
d(2) = 73.85+23.1;
d(3) = 25.0+5.0+6.0+15.0;
d(4) = 150;
d(5) = 24.0;
d(6) = 137.8+7.0+54.5;
d(7) = 70;
a(1) = 20;
a(2) = 13.3 + 20;
a(3) = 14;
% Symbolic variables
for i=1:7
    syms(strcat('q',num2str(i)), 'real');
    syms(strcat('d',num2str(i)), 'real');
    syms(strcat('a',num2str(i)), 'real');    
end
% Thumb Finger
T0_t =[ 0 1 0  -d2+d6;
        1 0 0  a1+a2-d4;
        0 0 -1 d1+d3-d5;
        0 0 0  1];
k_t = [0  0  1;
       -1 0  0;
       0  0  1;
       0  0  1;
       1  0  0;
       0  1  0;
       0  0  1];
p5 = [-d2+d6, a1+a2-d4, d1+d3-d5];
p_t = [ 0 0 0;
        0 a1 d1;
        -d2 a1+a2 0;
        -d2 a1+a2-d4 0;
        p5;
        p5;
        p5];
type = [1 1 1 1 1 1 1]; % All are revolute joints
% Middle Finger
k_m = [ 0  0  1;
        1 0  0;
        0  0  1;
        0  0  1;
        -1  0  0;
        0  1  0;
        0  0  1];
p5 = [d2-d6, -a1+a2-d4, d1+d3-d5];
p_m = [ 0 0 0;
        0 -a1 d1;
        d2 -a1+a2 0;
        d2 -a1+a2-d4 0;
        p5;
        p5;
        p5];
T0_m =[ 0 1 0  p5(1);
        1 0 0  p5(2);
        0 0 -1 p5(3);
        0 0 0  1];
% Index Finger
k_i = [ 0  0  1;
        0 cos(pi/4) sin(pi/4);
        -1 0  0;
        -1 0  0;
        0 -cos(pi/4) -sin(pi/4);
        -1 0 0;
        0 -cos(pi/4) sin(pi/4)];
p3 = [-d3, (a2+a3)*cos(pi/4), d1+d7+(a3-a2)*sin(pi/4)];
p4 = [p3(1), p3(2)-d4*cos(pi/4), p3(3)+d4*sin(pi/4)];
p5 = [p4(1)+d5, p4(2)-d6*cos(pi/4), p4(3)-d6*sin(pi/4)];
p_i = [ 0 0 0;
        0 0 d1+d7;
        p3;
        p4;
        p5;
        p5;
        p5];
T0_i =[ 0 1 0  p5(1);
        1 0 0  p5(2);
        0 0 -1 p5(3);
        0 0 0  1];
% Initial angles
initial_angles = [];
initial_angles(1) = 38.88 - 90;
initial_angles(2) = -49.64;
initial_angles(3) = 180-145.27;
initial_angles(4) = 90-18.19;
initial_angles(5) = 34.02;
initial_angles(6) = 117.79-180;
initial_angles(7) = 5.21;
initial_angles(8) = 6.28;
initial_angles(9) = -20.55;
initial_angles(10) = 60.98-180;
initial_angles = initial_angles * pi / 180;
% Finger offsets
offset_t = [-27.5187 -104.587 13.8364] - [-12 -90 20];
offset_m = [-4.16513 -91.0681 -0.408509] - [12 -90 20];
offset_i = [-20.0397 -113.129 41.4224] - [0 -90 40.785];
% Triangle centroid
triangle_centroid = ([-12 -90 20] + [12 -90 20] + [0 -90 40.785]) / 3;