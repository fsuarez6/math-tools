% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

clc; clear; close all;
% Get the files that include the pattern
home_dir = getuserdir();
dropbox_space = [home_dir '/Dropbox/doctorado/baxter/benchmark/'];
home_space = [home_dir '/benchmark/'];
if exist(dropbox_space, 'dir') == 7
  data_folder = dropbox_space;
elseif exist(home_space, 'dir') == 7
  data_folder = home_space;
else
  error('benchmark folder not found')
end
% Plots configuration
ColorSet = distinguishable_colors(3);
set(0,'DefaultAxesColorOrder', ColorSet);
set(0,'defaulttextinterpreter','latex');
filename = 'priovr_accuracy-2014-09-23-12-00-17.mat';
load([data_folder filename]);
time = time - min(time);
data_points = length(time);
rpy_error = zeros(data_points, 3);
q0_chest = Quaternion([chest(1,4) chest(1,1:3)]);
q0_baxter = Quaternion([baxter(1,4) baxter(1,1:3)]);
%~ for row = 2:data_points
for row = 1314
  q_chest =  Quaternion([chest(row,4) chest(row,1:3)]);
  q_baxter = q0_baxter.inv() * Quaternion([baxter(row,4) baxter(row,1:3)]);
  q_error = q_chest * q_baxter.inv();
  rpy_error(row,:) = tr2rpy(q_error.R);
  % Debug
  figure, q_chest.plot()
  figure, q_baxter.plot()
  figure, q_error.plot()
end

%~ close all;
%~ decimation = 1;
%~ figure, hold on, grid on; box on;
%~ % plot(time(1:decimation:end), rpy_error(1:decimation:end, 1:3));
%~ plot(rpy_error(1:decimation:end, 1:3));
%~ legend('roll', 'pitch', 'yaw');
