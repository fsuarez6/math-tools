% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

clc; clear; close all;
home_path = getuserdir();
data_folder = [getuserdir() '/Dropbox/doctorado/baxter/benchmark/'];
data_folder = [getuserdir() '/benchmark/'];
% Plots configuration
ColorSet = distinguishable_colors(3);
set(0,'DefaultAxesColorOrder', ColorSet);
set(0,'defaulttextinterpreter','latex');
bar_width = 0.4;
sensors = {'chest','r_upper_arm','r_lower_arm','r_hand'};
xyz_names = {'X','Y','Z'};
filename = 'priovr_drift-2014-09-16-16-07-18.mat';
load([data_folder filename]);
time = time - min(time);
data_points = length(time);
rpy_chest = zeros(data_points, 3);
rpy_upper = zeros(data_points, 3);
rpy_lower = zeros(data_points, 3);
rpy_hand = zeros(data_points, 3);
for i = 1:data_points
  q_chest = Quaternion([chest(i,4) chest(i,1) chest(i,2) chest(i,3)]);
  q_upper = Quaternion([r_upper_arm(i,4) r_upper_arm(i,1) r_upper_arm(i,2) r_upper_arm(i,3)]);
  q_lower = Quaternion([r_lower_arm(i,4) r_lower_arm(i,1) r_lower_arm(i,2) r_lower_arm(i,3)]);
  q_hand = Quaternion([r_hand(i,4) r_hand(i,1) r_hand(i,2) r_hand(i,3)]);
  rpy_chest(i,:) = tr2rpy(q_chest.R);
  rpy_upper(i,:) = tr2rpy(q_upper.R);
  rpy_lower(i,:) = tr2rpy(q_lower.R);
  rpy_hand(i,:) = tr2rpy(q_hand.R);
end
x_limits = [0 600];
y_limits = [-0.25 0.25];
x_dyn = [0 180];
x_sta = [180 600];
y_ticks = [-0.5:0.1:0.5];
decimation = 5;
height = '35mm';
width = '35mm';

tikz_folder = [getuserdir() '/git/icra-2015/tikz/'];

close all;
figure, hold on, grid on; box on;
plot(time(1:decimation:end), rpy_chest(1:decimation:end,:));
legend('roll', 'pitch', 'yaw');
fill([x_dyn(1) x_dyn(1) x_dyn(2) x_dyn(2)], [fliplr(y_limits) y_limits], 'k', 'EdgeColor','None', 'FaceAlpha', 0.2);
idx = find(time >= 200 & time <= 600);
y_change = [min(rpy_chest(idx,2)) max(rpy_chest(idx,2))];
fill([x_sta(1) x_sta(1) x_sta(2) x_sta(2)], [fliplr(y_change) y_change], 'b', 'EdgeColor','None', 'FaceAlpha', 0.2);
text(x_sta(1)-10, y_change(2)+0.012,['\scriptsize{ Range: ' num2str(diff(y_change), '%.3f') ' rad.}']);
xlim(x_limits);
ylim(y_limits);
set(gca,'YTick',y_ticks);
ylabel('Drifting [rad]');
xlabel('Time [s]');
matlab2tikz([tikz_folder 'chest_drift.tex'], 'standalone', true, 'showInfo',false,'height',...
        height,'width',width,'floatFormat','%.4f', 'extraAxisOptions',... 
        {'tick label style={font=\scriptsize}', 'label style={font=\small}', 'legend style={font=\scriptsize}'});

figure, hold on, grid on; box on;
plot(time(1:decimation:end), rpy_upper(1:decimation:end,:));
fill([x_dyn(1) x_dyn(1) x_dyn(2) x_dyn(2)], [fliplr(y_limits) y_limits], 'k', 'EdgeColor','None', 'FaceAlpha', 0.2);
idx = find(time >= 200 & time <= 600);
y_change = [min(rpy_upper(idx,2)) max(rpy_upper(idx,2))];
fill([x_sta(1) x_sta(1) x_sta(2) x_sta(2)], [fliplr(y_change) y_change], 'b', 'EdgeColor','None', 'FaceAlpha', 0.2);
text(x_sta(1)-10, y_change(2)+0.012,['\scriptsize{ Range: ' num2str(diff(y_change), '%.3f') ' rad.}']);
xlim(x_limits);
ylim(y_limits);
set(gca,'YTick',y_ticks);
xlabel('Time [s]');
set(gca, 'YTickLabel', [])
matlab2tikz([tikz_folder 'upper_drift.tex'], 'standalone', true, 'showInfo',false,'height',...
        height,'width',width,'floatFormat','%.4f', 'extraAxisOptions',...  
        {'tick label style={font=\scriptsize}', 'label style={font=\small}'});

figure, hold on, grid on; box on;
plot(time(1:decimation:end), rpy_lower(1:decimation:end,:));
fill([x_dyn(1) x_dyn(1) x_dyn(2) x_dyn(2)], [fliplr(y_limits) y_limits], 'k', 'EdgeColor','None', 'FaceAlpha', 0.2);
idx = find(time >= 200 & time <= 600);
y_change = [min(rpy_lower(idx,2)) max(rpy_lower(idx,2))];
fill([x_sta(1) x_sta(1) x_sta(2) x_sta(2)], [fliplr(y_change) y_change], 'b', 'EdgeColor','None', 'FaceAlpha', 0.2);
text(x_sta(1)-10, y_change(2)+0.012,['\scriptsize{ Range: ' num2str(diff(y_change), '%.3f') ' rad.}']);
xlim(x_limits);
ylim(y_limits);
set(gca,'YTick',y_ticks);
xlabel('Time [s]');
set(gca, 'YTickLabel', [])
matlab2tikz([tikz_folder 'lower_drift.tex'], 'standalone', true, 'showInfo',false,'height',...
        height,'width',width,'floatFormat','%.4f', 'extraAxisOptions',...  
        {'tick label style={font=\scriptsize}', 'label style={font=\small}'});
        
figure, hold on, grid on; box on;
plot(time(1:decimation:end), rpy_hand(1:decimation:end,:));
fill([x_dyn(1) x_dyn(1) x_dyn(2) x_dyn(2)], [fliplr(y_limits) y_limits], 'k', 'EdgeColor','None', 'FaceAlpha', 0.2);
idx = find(time >= 200 & time <= 600);
y_change = [min(rpy_hand(idx,2)) max(rpy_hand(idx,2))];
fill([x_sta(1) x_sta(1) x_sta(2) x_sta(2)], [fliplr(y_change) y_change], 'b', 'EdgeColor','None', 'FaceAlpha', 0.2);
text(x_sta(1)-10, y_change(2)+0.012,['\scriptsize{ Range: ' num2str(diff(y_change), '%.3f') ' rad.}']);
xlim(x_limits);
ylim(y_limits);
set(gca,'YTick',y_ticks);
xlabel('Time [s]');
set(gca, 'YTickLabel', [])
matlab2tikz([tikz_folder 'hand_drift.tex'], 'standalone', true, 'showInfo',false,'height',...
        height,'width',width,'floatFormat','%.4f', 'extraAxisOptions',...  
        {'tick label style={font=\scriptsize}', 'label style={font=\small}'});

tilefigs;
close all;
