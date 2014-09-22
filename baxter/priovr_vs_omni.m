% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

clc; clear; close all;
% Plots configuration
ColorSet = distinguishable_colors(7);
set(0,'DefaultAxesColorOrder', ColorSet);
set(0,'defaulttextinterpreter','latex');
% Get the files that include the pattern
home_path = getuserdir();
data_folder = [home_path '/experiments/'];
pattern = '-2014-09-';
extension = '*.mat';
filenames = get_files_by_pattern(data_folder, extension, pattern);

for f = 1:length(filenames)
  filename = filenames{f};
  load([data_folder filename]);
  % Crop the data between the start point and the last lock event
  locked(1) = [];
  time(1) = [];
  pose(1,:) = [];
  commanded_pose(1,:) = [];
  change_idxs = find(diff(locked)>0);
  samples = change_idxs(end);
  time(samples+1:end) = [];
  pose(samples+1:end,:) = [];
  commanded_pose(samples+1:end,:) = [];
  % Zero the time
  time = time - min(time);
  results(f).time = time;
  disp([filename ': ' num2str(max(time), '%.2f') ' seconds.']);
  % Plots
  if strcmp('omni-2014-09-18-13-43-21.mat', filename) && false
    region = 1:samples;
    figure, hold on; grid on; box on;
    plot(commanded_pose(region,2), commanded_pose(region,3), 'b');   % Y vs Z
    plot(pose(region,2), pose(region,3), 'r');   % Y vs Z
    figure, hold on; grid on; box on;
    plot(time, [commanded_pose(region,1)  pose(region,1)]);
    title('X tracking error');
    figure, hold on; grid on; box on;
    plot(time, [commanded_pose(region,2)  pose(region,2)]);
    title('Y tracking error');
    figure, hold on; grid on; box on;
    plot(time, [commanded_pose(region,3)  pose(region,3)]);
    title('Z tracking error');
  end
end
tilefigs;
