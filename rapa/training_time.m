% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

clc; clear; close all;
% Plots configuration
ColorSet = distinguishable_colors(3);
set(0,'DefaultAxesColorOrder', ColorSet);
set(0,'defaulttextinterpreter','latex');

extra_opts = {'tick label style={font=\scriptsize}', 'label style={font=\small}', 'legend style={font=\scriptsize}'};
tikz_folder = [getuserdir() '/git/phd-thesis/tikz/'];
height = '50mm';
width = '80mm';
y_limits = [0 140];
x_limits = [1 15];
step = 20;
% Data
rate =          [59, 88, 70, 72, 62, 35, 56, 57, 56, 40, 62, 38, 39, 38, 41];
indexing =      [78, 64, 101,73, 79, 85, 84, 76, 74, 64, 94, 66, 65, 81, 83];
manufacturer =  [70, 71, 42, 48, 55, 39, 68, 45, 59, 61, 50, 53, 35, 58, 41];
figure, hold on; grid on; box on;
plot(rate, '-rs');
plot(indexing, '--gd');
plot(manufacturer, ':bo');
lh = legend('Rate--Position', 'Indexing', 'Manufacturer');
%~ set(lh,'Location','NorthEastOutside');
ylabel('Time [s]');
xlabel('Trial Number');
xlim(x_limits);
ylim(y_limits);
set(gca,'XTick', x_limits(1):x_limits(2));
set(gca,'YTick', y_limits(1):step:y_limits(2));
matlab2tikz([tikz_folder 'rapa_training_time.tex'], 'standalone', true, 'showInfo',false,'height',...
    height,'width',width,'floatFormat','%.1f', 'extraAxisOptions',extra_opts);
