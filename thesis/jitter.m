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

time = 0.8 + 0.4.*rand(10,1);;
desired = 1.0;
x_limits = [0 length(time)+1];
y_limits = [0 1.3];
y_ticks = [0:0.2:max(y_limits)];
x_ticks = [1:length(time)];
height = '50mm';
width = '55mm';
extra_opts = {'tick label style={font=\scriptsize}', 'label style={font=\small}', 'legend style={font=\small}'};

tikz_folder = [getuserdir() '/git/phd-thesis/tikz/'];

close all;
figure, hold on, box on;
plot(x_limits, [desired desired], '--k', 'LineWidth', 0.8);
y_change = [min(time), max(time)];
fill([x_limits(1) x_limits(1) x_limits(2) x_limits(2)], [fliplr(y_change) y_change], 'k', 'EdgeColor','None', 'FaceAlpha', 0.25);
lh= legend('Desired time', 'Jitter');
set(lh,'Location','NorthEastOutside');
stem(time, '.b');
xlim(x_limits);
ylim(y_limits);
set(gca,'XTick',x_ticks);
set(gca,'YTick',y_ticks);
set(gca, 'YTickLabel', [])
ylabel('Loop Time');
xlabel('Loop Iteration');
%~ set(gca,'YGrid','on');
matlab2tikz([tikz_folder 'bico_jitter.tex'], 'standalone', true, 'showInfo',false,'height',...
        height,'width',width,'floatFormat','%.4f', 'extraAxisOptions',extra_opts);
