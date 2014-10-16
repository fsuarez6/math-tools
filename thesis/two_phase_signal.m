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

t = 0:1e-4:2/200;
f = 200;
vp = 1.92;
control = vp * sin(2*pi*f.*t);
fix = vp * sin(2*pi*f.*t + pi/2) / 1.2;
y_max = 1.25 * vp;
y_limits = [-y_max y_max];
height = '50mm';
width = '55mm';
extra_opts = {'tick label style={font=\small}', 'label style={font=\normalsize}', 'legend style={font=\small}'};

tikz_folder = [getuserdir() '/git/phd-thesis/tikz/'];

close all;
figure, hold on, box on; grid on;
plot(t*1000, fix, '-b', 'LineWidth', 0.8);
plot(t*1000, control, '--r', 'LineWidth', 0.8);
lh= legend('Fix Phase', 'Control Phase');
%~ set(lh,'Location','NorthEastOutside');
ylim(y_limits);
ylabel('Amplitude [V]');
xlabel('Time [ms]');
matlab2tikz([tikz_folder 'bico_two_phase_signal.tex'], 'standalone', true, 'showInfo',false,'height',...
        height,'width',width,'floatFormat','%.4f', 'extraAxisOptions',extra_opts);
