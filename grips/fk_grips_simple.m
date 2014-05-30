clc; clear;
% Robot dimensions
d = [15.24e-3 + 0.33812 + 0.001, 0.52167, 0.26109, 0.13322, 0.190892];
a = [9.82e-3, 7.5e-3, 0.051331, 0.787e-3];
% Se definen las variables para su uso simbolico
for i=1:6
    syms(strcat('q',num2str(i)), 'real');
    syms(strcat('d',num2str(i)), 'real');
end
% Robot parameters
T0 =[   1 0 0 0;
        0 1 0 d3+d4+d5;
        0 0 1 d1+d2;
        0 0 0 1];
k = [0 0 1;
     1 0 0;
     1 0 0;
     1 0 0;
     0 0 1;
     0 1 0];
p = [   0 0 0;
        0 0 d1;
        0 0 d1+d2;
        0 d3 d1+d2;
        0 d3+d4 d1+d2;
        0 0 d1+d2];
tipo = [1 1 1 1 1 1]; % Todas son de revolucion
[T0_6,D]=fk_dm(T0, k, p, tipo);

% T0_3
T0_0_3 =[1 0 0 0;
         0 1 0 d3;
         0 0 1 d1+d2;
         0 0 0 1];
[T0_3,D0_3]=fk_dm(T0_0_3, k(1:3,:), p(1:3,:), tipo(1:3));

% T3_6
T0_3_6=[1 0 0 0;
        0 1 0 d4+d5;
        0 0 1 0;
        0 0 0 1];
p3_6 =[ 0 0 0;
        0 d4 0;
        0 0 0];
[T3_6,D3_6]=fk_dm(T0_3_6, k(4:6,:), p3_6, tipo(4:6));
% Show results
simple(T0_3)
simple(T3_6)
