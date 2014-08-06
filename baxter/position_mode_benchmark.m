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
% Get the files that include the pattern
pattern = '_mode-';
extension = '.mat';
filenames = get_files_by_pattern(data_folder, ['*' extension], pattern);
% Plots configuration
ColorSet = distinguishable_colors(7);
set(0,'DefaultAxesColorOrder', ColorSet);
set(0,'defaulttextinterpreter','latex');

for f = 1:length(filenames)
  filename = filenames{f};
  control_mode = 'UNKNOWN';
  if not(isempty(strfind(filename, 'position')))
    control_mode = 'POSITION\_MODE';
  end
  if not(isempty(strfind(filename, 'raw')))
    control_mode = 'RAW\_POSITION\_MODE';
  end
  load([data_folder filename]);
  [test_cases, num_joints] = size(goal_angles);
  results(f).angles_rmse = ones(num_joints, 1) * -1;
  % ANGLES ANALYSIS
  % Absolute Error
  results(f).angles_error = abs(goal_angles - reached_angles);
  figure,
  boxplot(results(f).angles_error);
  xlabel('Joint Angles Absolute Error');
  title(control_mode);
  % Root Mean Squared Error
  results(f).angles_rmse = sqrt(mean((goal_angles - reached_angles).^2));
  figure,
  bar(results(f).angles_rmse);
  xlabel('Joint Angles Root Mean Squared Error');
  title(control_mode);
  % XYZ ANALYSIS
  goal_position = goal_poses(:,1:3);
  reached_position = reached_poses(:,1:3);
  % Absolute Error
  results(f).position_error = abs(goal_position - reached_position);
  figure,
  boxplot(results(f).position_error);
  xlabel('Position Absolute Error');
  title(control_mode);
  % Root Mean Squared Error
  results(f).position_rmse = sqrt(mean((goal_position - reached_position).^2));
  figure,
  bar(results(f).position_rmse);
  xlabel('Position Root Mean Squared Error');
  title(control_mode);
end

tilefigs;
