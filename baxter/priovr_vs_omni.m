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
% Get the files that include the pattern
home_dir = getuserdir();
dropbox_space = [home_dir '/Dropbox/doctorado/baxter/experiments/'];
home_space = [home_dir '/experiments/'];
if exist(dropbox_space, 'dir') == 7
  data_folder = dropbox_space;
elseif exist(home_space, 'dir') == 7
  data_folder = home_space;
else
  error('experiments folder not found')
end
pattern = '-2014-09-';
extension = '*.mat';
filenames = get_files_by_pattern(data_folder, extension, pattern);
omni_times = [];
priovr_times = [];
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
  disp([filename ': ' num2str(time(end), '%.2f') ' seconds.']);
  if not(isempty(strfind(filename, 'omni')))
    omni_times(end+1) = time(end);
  elseif not(isempty(strfind(filename, 'priovr')))
    priovr_times(end+1) = time(end);
  end
  % Plots
  %~ if strcmp('omni-2014-09-18-13-43-21.mat', filename) && false
  if strcmp('omni-2014-09-19-18-40-46.mat', filename)
    extra_opts = {'tick label style={font=\scriptsize}', 'label style={font=\footnotesize}', 'legend style={font=\scriptsize}'};
    tikz_folder = [home_dir '/git/icra-2015/tikz/'];
    region = 1:samples;
    height = '35mm';
    width = '33mm';
    y_limits = [0.5 0.9];
    step = 0.1;
    figure, hold on; grid on; box on;
    plot(time, commanded_pose(region, 1), 'b');
    plot(time, pose(region, 1), '--r');
    legend('Target', 'JT Controller')
    ylabel('Position [m]');
    xlabel('Time [s]');
    xlim([0 50]);
    ylim(y_limits);
    set(gca,'YTick', y_limits(1):step:y_limits(2));
    matlab2tikz([tikz_folder 'bax_x_tracking.tex'], 'standalone', true, 'showInfo',false,'height',...
        height,'width',width,'floatFormat','%.4f', 'extraAxisOptions',extra_opts);
    y_limits = [-0.7 -0.2];
    figure, hold on; grid on; box on;
    plot(time, commanded_pose(region, 2), 'b');
    plot(time, pose(region, 2), '--r');
    xlabel('Time [s]');
    xlim([0 50]);
    ylim(y_limits);
    set(gca,'YTick', y_limits(1):step:y_limits(2));
    matlab2tikz([tikz_folder 'bax_y_tracking.tex'], 'standalone', true, 'showInfo',false,'height',...
        height,'width',width,'floatFormat','%.4f', 'extraAxisOptions',extra_opts);
    y_limits = [0 0.4];
    figure, hold on; grid on; box on;
    plot(time, commanded_pose(region, 3), 'b');
    plot(time, pose(region, 3), '--r');
    xlabel('Time [s]');
    xlim([0 50]);
    ylim(y_limits);
    set(gca,'YTick', y_limits(1):step:y_limits(2));
    matlab2tikz([tikz_folder 'bax_z_tracking.tex'], 'standalone', true, 'showInfo',false,'height',...
        height,'width',width,'floatFormat','%.4f', 'extraAxisOptions',extra_opts);
    % Position error
    y_limits = [-0.2 0.2];
    figure, hold on; grid on; box on;
    pos_error = commanded_pose(:,1:3) - pose(:,1:3);
    decimation = 5;
    plot(time(1:decimation:end), pos_error(1:decimation:end,1), ':b');
    plot(time(1:decimation:end), pos_error(1:decimation:end,2), '--r')
    plot(time(1:decimation:end), pos_error(1:decimation:end,3), '-g')
    legend('X', 'Y', 'Z')
    xlabel('Time [s]');
    xlim([0 50]);
    ylim(y_limits);
    set(gca,'YTick', y_limits(1):step:y_limits(2));
    matlab2tikz([tikz_folder 'bax_tracking_error.tex'], 'standalone', true, 'showInfo',false,'height',...
        height,'width',width,'floatFormat','%.4f', 'extraAxisOptions',extra_opts);
    tilefigs;
  end
end
figure,
stats = boxplot_data('omni', omni_times, 1);
m = stats.median;
lw = stats.lower_wisker;
uw = stats.upper_wisker;
lav = stats.lower_adjacent_value;
uav = stats.upper_adjacent_value;
disp(['Omni   ' num2str([m uw lw uav lav])]);
figure,
stats = boxplot_data('priovr', priovr_times, 1);
m = stats.median;
lw = stats.lower_wisker;
uw = stats.upper_wisker;
lav = stats.lower_adjacent_value;
uav = stats.upper_adjacent_value;
disp(['PrioVR   ' num2str([m uw lw uav lav])]);

