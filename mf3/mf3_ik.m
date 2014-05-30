addpath(strcat(pwd, '/mcd'));
addpath(strcat(pwd, '/xml'));
clc; clear;
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
       0  0  1];
p_t = [ 0 0 0;
        0 a1 d1;
        -d2 a1+a2 0;
        -d2 a1+a2-d4 0];
type = [1 1 1 1]; % All are revolute joints
[T_thumb,D_thumb]=mcd_md(T0_t, k_t, p_t, type);
ccode(T_thumb)