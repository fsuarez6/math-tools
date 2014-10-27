% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

clc; clear; close all;
folder_path = '/media/Share/vrc_videos/vrc/log_files/';
filename = 'vrc_netwatcher_usage.log';
folders = get_folder_list(folder_path);
runs = length(folders);
% Plots configuration
ColorSet = distinguishable_colors(6);
set(0,'DefaultAxesColorOrder', ColorSet);
set(0,'defaulttextinterpreter','latex');

up_limits = [16384 4096 1024 256 64];
down_limits = [524288 262144 131072 65536 32768];

for i=1:runs
    txt = importdata(strcat(folder_path, folders{i}, '/', filename));
    data = txt.data(2:end,:);
    [up_bytes(i), up_index(i)] = max(data(:, 3));
    t_up(i) = data(up_index(i), 2) - data(1, 2);
    
    [down_bytes(i), down_index(i)] = max(data(:, 4));
    t_down(i) = data(down_index(i), 3) - data(1, 3);
    
    up(i) = up_bytes(i) * 8 / t_up(i);
    down(i) = down_bytes(i) * 8 / t_down(i);
    
    current_task =  ceil(i/5);
    current_run = i - 5 * (current_task-1);
    uplink(current_run, current_task) = 100*up_bytes(i) / (1800*up_limits(current_run)/8);
    downlink(current_run, current_task) = 100*down_bytes(i) / (1800*down_limits(current_run)/8);
end

tikz_folder = [getuserdir() '/git/phd-thesis/tikz/'];
extra_opts = {'tick label style={font=\scriptsize}', 'label style={font=\small}', 'legend style={font=\scriptsize}'};
fig_height = '50mm';
fig_width = '80mm';
bar_width = 1.0;
y_step = 10;
x_limits = [0.5 5.5];

figure;
uplink(5,2) = 100;
bar(uplink, bar_width)
xlim(x_limits);
y_limits = [0 105];
ylim(y_limits);
xlabel('Run');
ylabel('Consumed Data [\%]');
legend('Task 1', 'Task 2', 'Task 3', 'Location', 'NorthWest');
set(gca,'YGrid','on');
set(gca, 'YTick',y_limits(1):y_step:y_limits(2));
colormap bone;
matlab2tikz([tikz_folder 'super_uplink.tex'], 'standalone', true, 'showInfo',false,'height',...
        fig_height,'width',fig_width,'floatFormat','%.4f','extraAxisOptions',extra_opts);

figure;
bar(downlink, bar_width);
xlim(x_limits);
y_limits = [0 55];
ylim(y_limits);
xlabel('Run');
ylabel('Consumed Data [\%]');
legend('Task 1', 'Task 2', 'Task 3', 'Location', 'NorthWest');
set(gca,'YGrid','on');
set(gca, 'YTick',y_limits(1):y_step:y_limits(2));
colormap bone;
matlab2tikz([tikz_folder 'super_downlink.tex'], 'standalone', true, 'showInfo',false,'height',...
        fig_height,'width',fig_width,'floatFormat','%.4f','extraAxisOptions',extra_opts);
%~ tilefigs;
