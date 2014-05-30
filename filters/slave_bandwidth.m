startup;
clc; clear; close all;
load('data/wp_bandwidth.mat');
joint = 4;
[wp_x, wp_y] = calculate_magnitude(slave_pos(:, joint), slave_pos_cmd(:, joint), sine_freq);
load('data/wy_bandwidth.mat');
joint = 5;
[wy_x, wy_y] = calculate_magnitude(slave_pos(:, joint), slave_pos_cmd(:, joint), sine_freq);
load('data/wr_bandwidth.mat');
joint = 6;
[wr_x, wr_y] = calculate_magnitude(slave_pos(:, joint), slave_pos_cmd(:, joint), sine_freq);
% Plot the results
figure, plot(wp_x, wp_y,'s-'); grid on;
title('WP');
figure, plot(wy_x, wy_y,'s-'); grid on;
title('WY');
figure, plot(wr_x, wr_y,'s-'); grid on;
title('WR');