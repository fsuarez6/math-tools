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
bar_width = 0.4;
joint_names = {'s0','s1','e0','e1','w0','w1','w2'};
xyz_names = {'X','Y','Z'};
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
  % Root Mean Squared Error
  results(f).angles_rmse = sqrt(mean((goal_angles - reached_angles).^2));
  % XYZ ANALYSIS
  goal_position = goal_poses(:,1:3);
  reached_position = reached_poses(:,1:3);
  % Absolute Error
  results(f).position_error = abs(goal_position - reached_position);
  % Root Mean Squared Error
  results(f).position_rmse = sqrt(mean((goal_position - reached_position).^2));
  % PLOT everything
  figure('units','normalized','outerposition',[0 0 1 1])
  ax(1) = subplot(2,2,1);
  boxplot(results(f).angles_error);
  title('Angles Abs Error [rad]');
  xlabel('Joint');
  set(gca,'xTick',1:length(joint_names), 'XTickLabel', joint_names);
  ax(3) = subplot(2,2,3);
  bar(results(f).angles_rmse, bar_width);
  title('Angles RMSE [rad]');
  xlabel('Joint');
  set(gca,'XTickLabel', joint_names);
  ax(2) = subplot(2,2,2);
  boxplot(results(f).position_error * 1000);
  title('Position Abs Error [mm]');
  xlabel('Coordinate');
  set(gca,'xTick',1:length(xyz_names), 'XTickLabel', xyz_names);
  ax(4) = subplot(2,2,4);
  bar(results(f).position_rmse * 1000, bar_width/2);
  title('Position RMSE [mm]');
  xlabel('Coordinate');
  set(gca,'XTickLabel', xyz_names);
  suplabel(control_mode, 't');
  % Improve the look
  % find current position [x,y,width,height]
  for p = 1:4
    pos(p,:) = get(ax(p),'Position');
  end
  % Set the x and width of first axes equal to second
  pos(1,1) = pos(3,1);
  pos(1,3) = pos(3,3);
  pos(2,1) = pos(4,1);
  pos(2,3) = pos(4,3);
  set(ax(1),'Position',pos(1,:));
  set(ax(2),'Position',pos(2,:));
end

