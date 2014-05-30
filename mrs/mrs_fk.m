clc; clear;
% Robot dimensions
d = [50 150 50 50];
% Define the symbolic variable
for i=1:6
    syms(strcat('q_',num2str(i)), 'real');
    syms(strcat('d_',num2str(i)), 'real');
end
% DH Parameter
DH = [q_1 d_1 0 -pi/2;
      q_2 0 0 pi/2;
      q_3 d_2 0 0;
      q_4 d_3 0 -pi/2;
      q_5 0 0 pi/2;
      q_6 d_4 0 0];
[T,A]=fk_dh(DH);
A = simple(A);
T = simple(T);
A
T