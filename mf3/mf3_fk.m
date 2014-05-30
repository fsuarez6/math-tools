addpath(strcat(pwd, '/fk'));
clc; clear;
kinematic_parameters;
% Forward kinematics
[T_thumb,D_thumb]=fk_dm(T0_t, k_t, p_t, type);
%[T_middle,D_middle]=fk_dm(T0_m, k_m, p_m, type);
%[T_index,D_index]=fk_dm(T0_i, k_i, p_i, type);
% Jacobian Thumb
q = [0, 1.25, 0.73, -0.57, 0, 0, 0];
q = zeros(1, 7);
k = k_t(1:4,:);
p = p_t(1:4,:);
[T, D] = fk_dm(T0_t, k, p, ones(1,4));
p = eval_sym(p, q, d, a);
T = eval_sym(T, q, d, a);
D = eval_sym(D, q, d, a);
J = geometric_jacobian(k, p, ones(1,4), T, D);
% Utilities
% Generate cpp code
%ccode(T_middle)