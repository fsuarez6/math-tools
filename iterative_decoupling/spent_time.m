% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

% Performance comparison
clear; close all;
home_path = getuserdir();
data_folder = [getuserdir() '/Dropbox/doctorado/publications/2014_kinematics/test/'];
methods = {'kdl','lma','ikfast','decoup'};
labels = {'N--R','L--M','IKFast','I--D'};
[rows, cols] = size(methods);
% boxplot data
disp('Method  median  upper_wisker  lower_wisker   upper_adjacent_value   lower_adjacent_value');
for i = 1:cols
  name = methods{i};
  load([data_folder name '.mat']);
  idx = iterations > 0;
  results(i).iterations = iterations(idx);
  results(i).joint_errors = joint_errors(idx);
  results(i).joint_positions = joint_positions(idx);
  results(i).poses = poses(idx);
  results(i).time = time(idx);
  results(i).solved = 100 * sum(idx) / length(iterations);
  stats = boxplot_data(labels{i}, results(i).time, 1000);
  results(i).stats = stats;
  m = stats.median;
  lw = stats.lower_wisker;
  uw = stats.upper_wisker;
  lav = stats.lower_adjacent_value;
  uav = stats.upper_adjacent_value;
  disp([labels{i} '   ' num2str([m uw lw uav lav])]);
end

% Performance table
disp(' ')
disp('Method    Solved [%]    Median [ms.]   Mean [ms.]');
for i = 1:cols
  disp([labels{i} '   ' num2str([results(i).solved results(i).stats.median results(i).stats.mean])]);
end

% Time histograms
tikz_folder = [getuserdir() '/git/kinematics-journal/tikz/'];
set(0,'defaulttextinterpreter','latex');
titles = {'Newton-Raphson','Levenberg-Marquardt','IKFast','Iterative-Decoupling'};
filenames = {'kdl_time_hist','lma_time_hist','ikfast_hist','decoup_time_hist'};
for i = 1:cols
  figure,
  xlimit = 25;
  num_bars = 100;
  hist(results(i).time * 1000, 0:xlimit / num_bars:xlimit);
  %hist(results(i).time * 1000, num_bars);
  xlabel('Time [ms.]');
  ylabel('log(Frequency)');
  title(titles{i});
  %~ % Workaround
  %~ % Get histogram patches
  %~ ph = get(gca,'children');
  %~ % Determine number of histogram patches
  %~ N_patches = length(ph);
  %~ for j = 1:N_patches
   %~ % Get patch vertices
   %~ vn = get(ph(j),'Vertices');
   %~ % Adjust y location
   %~ vn(:,2) = vn(:,2) + 1;
   %~ % Reset data
   %~ set(ph(j),'Vertices',vn)
  %~ end
  %~ % Change scale
  %~ set(gca,'yscale','log')
  % Save the tikz figures
  grid on;
  xlim([0 xlimit]);
  % ylim([0 1e5]);
  matlab2tikz([tikz_folder filenames{i} '.tex'], 'standalone', true, 'showInfo',false,'height',...
        '50mm','width','50mm','floatFormat','%.4f');
end
tilefigs;
