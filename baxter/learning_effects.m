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
  plot(ax1, 100 * (omni_times(1) - omni_times) / omni_times(1), line_types{user_num}, 'LineWidth', 0.8);
  plot(ax2, 100 * (priovr_times(1) - priovr_times) / priovr_times(1), line_types{user_num}, 'LineWidth', 0.8);
end
% Tikz files
extra_opts = {'enlarge x limits=0.1', 'legend style={font=\scriptsize}'};
tikz_folder = [getuserdir() '/git/phd-thesis/tikz/'];
fig_height = '50mm';
fig_width = '50mm';
x_limits = [1 3];
y_limits = [-30 40];
y_step = 10;
% Plots improvement
set(0, 'Currentfigure', fig1);
xlim(x_limits);
ylim(y_limits);
xlabel('Trial Number');
ylabel('Learning Effect [\%]');
set(gca, 'XTick',x_limits(1):x_limits(2));
set(gca, 'YTick',-20:10:30);
matlab2tikz([tikz_folder 'bax_learning_omni.tex'], 'standalone', true, 'showInfo',false,'height',...
        fig_height,'width',fig_width,'floatFormat','%.4f','extraAxisOptions',extra_opts);

set(0, 'Currentfigure', fig2);
xlim(x_limits);
ylim(y_limits);
xlabel('Trial Number');
set(gca, 'XTick',x_limits(1):x_limits(2));
set(gca, 'YTick',y_limits(1):y_step:y_limits(2));
set(gca, 'YTickLabel', []);
lh = legend(user_legend);
set(lh, 'Location', 'NorthEastOutside');
matlab2tikz([tikz_folder 'bax_learning_priovr.tex'], 'standalone', true, 'showInfo',false,'height',...
        fig_height,'width',fig_width,'floatFormat','%.4f','extraAxisOptions',extra_opts);

tilefigs;
