clc; clear;
% Robot dimensions
d = [15.24e-3 + 0.33812 + 0.001, 0.52167, 0.26109, 0.13322, 0.190892];
a = [9.82e-3, 7.5e-3, 0.051331, 0.787e-3];
% Se definen las variables para su uso simbolico
for i=1:6
    syms(strcat('q',num2str(i)), 'real');
    syms(strcat('d',num2str(i)), 'real');
    syms(strcat('a',num2str(i)), 'real');    
end
% Par�metros del robot de 6GDL dado para el trabajo 1.
T0 =[   1 0 0 -a4;
        0 1 0 -a1+d3+d4+d5;
        0 0 1 d1+d2+a2+a3;
        0 0 0 1];
k = [0 0 1;
     1 0 0;
     1 0 0;
     1 0 0;
     0 0 1;
     0 1 0];
p = [   0 0 0;
        0 0 d1;
        0 -a1 d1+d2;
        0 -a1+d3 d1+d2+a2;
        0 -a1+d3+d4 d1+d2+a2;
        -a4 0 d1+d2+a2+a3];
tipo = [1 1 1 1 1 1]; % Todas son de revolucion
[T0_6,D]=MCD_MD(T0, k, p, tipo);

% T0_3
T0_0_3 =[1 0 0 0;
         0 1 0 -a1+d3;
         0 0 1 d1+d2+a2;
         0 0 0 1];
[T0_3,D0_3]=MCD_MD(T0_0_3, k(1:3,:), p(1:3,:), tipo(1:3));

% T3_6
T0_3_6=[1 0 0 -a4;
        0 1 0 d4+d5;
        0 0 1 a3;
        0 0 0 1];
p3_6 =[ 0 0 0;
        0 d4 0;
        -a4 0 a3];
[T3_6,D3_6]=MCD_MD(T0_3_6, k(4:6,:), p3_6, tipo(4:6));
% Generate cpp code
ccode(T0_6)
ccode(T0_3)
ccode(T3_6)
% Validate the results
% q = [0.15, 0.15, 0.15, 0.15, 0.15, 0.15];
% q = zeros(1, 6);
% Evalua_T(T0_6, q, d, a)
%   0.937094   -0.28081   0.207366 -0.0927899
%   0.341928   0.858007  -0.383288   0.417853
% -0.0702906   0.430081    0.90005    1.13924
%          0          0          0          1
% Evalua_T(T0_3, q, d, a)*Evalua_T(T3_6, q(4:6), d, a) - Evalua_T(T0_6, q, d, a)