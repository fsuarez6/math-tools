% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

clc; clear; close all;
Fs = 500;
% Get the files that include the pattern
home_dir = getuserdir();
dropbox_space = [home_dir '/Dropbox/doctorado/ft_sensor/'];
home_space = [home_dir '/data/ft_sensor/'];
if exist(home_space, 'dir') == 7
  data_folder = home_space;
elseif exist(dropbox_space, 'dir') == 7
  data_folder = dropbox_space;
else
  error('data folder not found')
end
pattern = 'dynamic_compensation';
extension = '*.bag';
filenames = get_files_by_pattern(data_folder, extension, pattern);
for f = 1:length(filenames)
%~ for f = 1:1
  filename = filenames{f};
  disp(filename);
  bag = ros.Bag.load([data_folder filename]);
  msg_data = bag.readAll({'/netft/data'});
  msg_filtered = bag.readAll({'/netft/filtered'});
  msg_compensated = bag.readAll({'/netft/compensated'});
  msg_ik_command = bag.readAll({'/grips/ik_command'});
  msg_state = bag.readAll({'/grips/endpoint_state'});
  % Get timestamps
  t_state = cellfun(@(msg) msg.header.stamp.time, msg_state);
  t_ik = cellfun(@(msg) msg.header.stamp.time, msg_ik_command);
  t_data = cellfun(@(msg) msg.header.stamp.time, msg_data);
  t_filt = cellfun(@(msg) msg.header.stamp.time, msg_filtered);
  t_comp = cellfun(@(msg) msg.header.stamp.time, msg_compensated);
  range_comp = [min(t_comp) max(t_comp)];
  first_idx = find(t_filt >= min(t_comp), 1, 'first');
  last_idx = find(t_filt <= max(t_comp), 1, 'last');
  % Convert structure to 3-by-N matrix
  force_data = ros.msgs2mat(msg_data,         @(msg) msg.wrench.force)';
  force_filt = ros.msgs2mat(msg_filtered,     @(msg) msg.wrench.force)';
  force_comp = ros.msgs2mat(msg_compensated,  @(msg) msg.wrench.force)';
  % Estimate acceleration
  v_raw = ros.msgs2mat(msg_state, @(msg) msg.twist.linear)';
  w_raw = ros.msgs2mat(msg_state, @(msg) msg.twist.angular)';
  
  % Plot trajectory
  setpoint = ros.msgs2mat(msg_ik_command, @(msg) msg.pose.position)';
  pos = ros.msgs2mat(msg_state,      @(msg) msg.pose.position)';
  position = zeros(200, 3);
  for i = 1:200
    match_idx = find(t_state >= t_ik(i), 1, 'first');
    position(i, :) = pos(match_idx, :);
  end
  figure;
  subplot(1,2,1); hold on;  grid on; box on;
  plot(setpoint(1:200,1), setpoint(1:200,3), '-k', 'LineWidth', 2.0);
  plot(position(:,1), position(:,3) + 0.03, 'r--', 'LineWidth', 2.0);
  legend({'Setpoint','Position'});
  xlabel('X Position [m]');  ylabel('Z Position [m]');
  axis([-0.3 0.3 0.4 0.6]);
  subplot(1,2,2); hold on;  grid on; box on;
  plot(setpoint(1:200,2), setpoint(1:200,3), '-k', 'LineWidth', 2.0);
  plot(position(:,2) - 0.03, position(:,3) + 0.03, 'r--', 'LineWidth', 2.0);
  legend({'Setpoint','Position'});
  xlabel('Y Position [m]');  ylabel('Z Position [m]');
  axis([0.6 1.2 0.4 0.6]);
  
  % Smooth signals
  v = sgolayfilt(v_raw, 7, 51);
  w = sgolayfilt(w_raw, 7, 51);
  a = filter(-smooth_diff(51), 1, v) * Fs;
  alpha = filter(-smooth_diff(51), 1, w) * Fs;
  m = 2.52;
  c = [0.008 0.0 0.089];
  mc = m*c;
  rot = ros.msgs2mat(msg_state, @(msg) msg.pose.orientation)';
  [rows, cols] = size(rot);
  fe = zeros(rows, 3);
  ff = zeros(rows, 3);
  for i = 1:rows
    % Calculate the gravity vector in the reference frame of the F/T sensor
    q = Quaternion([rot(i,4) rot(i,1:3)]);
    g = [0,0,-9.80665] * q.R;
    % Estimate the force/torque to be removed from the sensor readings
    fe(i,:) = m*a(i,:) - m*g + cross(alpha(i,:), mc) + cross(w(i,:), cross(w(i,:), mc));
    % Down-sample filtered signal
    match_idx = find(t_filt >= t_state(i), 1, 'first');
    % TODO: Fz was inverted using F/T sensor webserver
    ff(i,:) = [force_filt(match_idx,1) force_filt(match_idx,2) -force_filt(match_idx,3)];
  end
  bias = [4.288  -4.647   -2.632];
  ff_bias = bsxfun(@minus, ff, bias);
  fc = ff_bias - fe;
  figure; hold on;  grid on;
  t = t_state - min(t_state);
  plot(t, ff_bias);
  legend({'X','Y','Z'});
  title('Filtered Force');
  figure; hold on;  grid on;
  plot(t, fe);
  legend({'X','Y','Z'});
  title('Estimated Force');
  % Lowpass Butterworth filter
  nyq = 0.5 * Fs;
  [b,a] = butter(10, 10/nyq, 'low');
  fc_filt = filter(b, a, fc);
  figure; hold on;  grid on;
  plot(t, fc_filt);
  legend({'X','Y','Z'});
  title('Compensated Force');
  ylim([-30 10]);
end
