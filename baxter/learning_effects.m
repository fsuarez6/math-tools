% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

clc; clear; close all;
% Plots configuration
ColorSet = distinguishable_colors(6);
set(0,'DefaultAxesColorOrder', ColorSet);
set(0,'defaulttextinterpreter','latex');
% Define 6 distinguishable line styles
line_types = {'-r+','--go',':b.','-.cd','-ms','--kx'};
% Get the files that include the pattern
home_dir = getuserdir();
dropbox_space = [home_dir '/Dropbox/doctorado/baxter/experiments/'];
home_space = [home_dir '/experiments/'];
if exist(home_space, 'dir') == 7
  data_folder = home_space;
elseif exist(dropbox_space, 'dir') == 7
  data_folder = dropbox_space;
else
  error('experiments folder not found')
end
% File management crap
extension = '*.mat';
users = get_folder_list(data_folder);
fig1 = figure; grid on; hold on; box on;
ax1 = gca;
fig2 = figure; grid on; hold on; box on;
ax2 = gca;
first_omni = [];
first_priovr = [];
%~ omni_users = zeros(length(users), 2);
%~ priovr_users = zeros(length(users), 2);
for user_num = 1:length(users)
  user = users{user_num};
  if not(isempty(strfind(user, '07')))
    % Skip user 07 because didn't completed all the trials
    continue
  end
  user_legend{user_num} = ['User ' num2str(user_num)];
  filenames = get_files_by_pattern(fullfile(data_folder, user), extension, '-2014-09-');
  omni_times = [];
  priovr_times = [];
  for f = 1:length(filenames)
    filename = filenames{f};
    load(fullfile(data_folder, user, filename));
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
  end
  omni_learning_effect = 100 * (omni_times(1) - omni_times) / omni_times(1);
  priovr_learning_effect = 100 * (priovr_times(1) - priovr_times) / priovr_times(1);
  plot(ax1, omni_learning_effect, line_types{user_num}, 'LineWidth', 0.8);
  plot(ax2, priovr_learning_effect, line_types{user_num}, 'LineWidth', 0.8);
  omni_learning_effect = (omni_times(1) - omni_times);
  priovr_learning_effect = (priovr_times(1) - priovr_times);
  omni_users(:,user_num) = omni_learning_effect(2:end);
  priovr_users(:,user_num) = priovr_learning_effect(2:end);
  omni_user_times(user_num, :) = omni_times;
  priovr_user_times(user_num, :) = priovr_times;
end

% Common variables
close all;
tikz_folder = [getuserdir() '/git/phd-thesis/tikz/'];
extra_opts = {'tick label style={font=\scriptsize}', 'label style={font=\small}', 'legend style={font=\scriptsize}'};
fig_height = '50mm';
fig_width = '58mm';
bar_width = 1.0;

% Completion time bar plots
y_limits = [0 220];
y_step = 20;
figure, grid on;
bar(omni_user_times, bar_width);
xlabel('User Number');
ylabel('Completion Time [s]');
ylim(y_limits);
set(gca, 'YGrid', 'on');
set(gca, 'YTick',y_limits(1):y_step:y_limits(2));
lh = legend('Trial 1', 'Trial 2', 'Trial 3');
set(lh, 'Location', 'NorthWest');
colormap bone;
matlab2tikz([tikz_folder 'bax_completion_omni.tex'], 'standalone', true, 'showInfo',false,'height',...
        fig_height,'width',fig_width,'floatFormat','%.4f','extraAxisOptions',extra_opts);

figure, grid on;
bar(priovr_user_times, bar_width);
xlabel('User Number');
ylim(y_limits);
set(gca, 'YGrid', 'on');
set(gca, 'YTick',y_limits(1):y_step:y_limits(2));
colormap bone;
matlab2tikz([tikz_folder 'bax_completion_priovr.tex'], 'standalone', true, 'showInfo',false,'height',...
        fig_height,'width',fig_width,'floatFormat','%.4f','extraAxisOptions',extra_opts);

% Time Improvement bar plots
x_limits = [1.6 3.4];
y_limits = [-20 80];
y_step = 10;
figure, bar(2:0.5:3, [omni_users(1,:) ; repmat(NaN,1,6) ; omni_users(2,:)], bar_width);
xlim(x_limits);
ylim(y_limits);
xlabel('Trial Number');
ylabel('Time Improvement [s]');
set(gca, 'YGrid', 'on');
lh = legend(user_legend);
set(gca,'xtick',2:3);
set(gca, 'YTick',y_limits(1):y_step:y_limits(2));
colormap bone;
matlab2tikz([tikz_folder 'bax_learning_omni.tex'], 'standalone', true, 'showInfo',false,'height',...
        fig_height,'width',fig_width,'floatFormat','%.4f','extraAxisOptions',extra_opts);

figure, bar(2:0.5:3, [priovr_users(1,:) ; repmat(NaN,1,6) ; priovr_users(2,:)], bar_width);
xlim(x_limits);
ylim(y_limits);
xlabel('Trial Number');
set(gca, 'YGrid', 'on');
%~ set(gca, 'YTickLabel', []);
set(gca,'xtick',2:3);
set(gca, 'YTick',y_limits(1):y_step:y_limits(2));
colormap bone;
matlab2tikz([tikz_folder 'bax_learning_priovr.tex'], 'standalone', true, 'showInfo',false,'height',...
        fig_height,'width',fig_width,'floatFormat','%.4f','extraAxisOptions',extra_opts);


fig_height = '50mm';
fig_width = '80mm';
manual = [27.98
25.59
28.74
21.31
23.47
21.53
23.08
19.33
19.74
20.01];
y_limits = [0 30];
y_step = 5;
figure; grid on; hold on; box on;
plot(manual, '--ks', 'LineWidth', 0.8);
xlabel('Trial Number');
ylabel('Task Completion Time [s]');
ylim(y_limits);
set(gca, 'YTick',y_limits(1):y_step:y_limits(2));
set(gca, 'XTick',1:length(manual));
tilefigs;
matlab2tikz([tikz_folder 'bax_manual_time.tex'], 'standalone', true, 'showInfo',false,'height',...
        fig_height,'width',fig_width,'floatFormat','%.4f','extraAxisOptions',extra_opts);
