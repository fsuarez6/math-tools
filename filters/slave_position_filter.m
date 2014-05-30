clc; clear; close all;
load('data/slave_noise.mat');
T = 0.001;  % sec
sa = slave_pos(1e3:11e3,1);
F_sa = fft(sa);
% Low pass filter
fc = 25; %Hz
F = tf(1,[1/fc 1]);
Fz = c2d(F, T);
num = Fz.num{:}(2)    
den = Fz.den{:}
sa_filtered = filter(num, den, sa);
% Plot the results
figure, plot(sa, 'b'); grid on;
hold on; plot(sa_filtered, 'r', 'LineWidth', 2);