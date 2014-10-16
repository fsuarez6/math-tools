% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

clear; close all; clc;
home_path = getuserdir();
data_folder = [getuserdir() '/journal_data/'];
% Get the files that include the pattern
pattern = '_inc_';
extension = '.mat';
filenames = get_files_by_pattern(data_folder, ['*' extension], pattern);

for f = 1:length(filenames)
  filename = filenames{f};
  load([data_folder filename]);
  idx = iterations > 0;
  n = sscanf(filename, ['decoup' pattern '%f' extension]);
  max_step_size(f) = n(1);
  mean_time(f) = mean(time(idx));;
  median_time(f) = median(time(idx));
  solved(f) = 100 * sum(idx) / length(iterations);
end

[step_size, idx] = sort(max_step_size);
x = 1:length(idx);
y1 = solved(idx);
y2 = mean_time(idx) .^ (-1);
%~ y2 = mean_time(idx) * 1000;
set(0,'defaulttextinterpreter','latex');
figure,
[ax,h1,h2] = plotyy(x, y1, x, y2);
% Fix the figure axis
% X axis
xlim(ax(1), [1 length(idx)]);
xlim(ax(2), [1 length(idx)]);
set(ax(1),'XTick', x);
set(ax(1),'XTickLabel', step_size);
set(ax(2),'xticklab',[],'xtick',[]);
% Y axis
y1_lim = [0 100];
y2_lim = [0 800];
yticks = 10;
ylim(ax(1), y1_lim);
ylim(ax(2), y2_lim);
set(ax(1),'YTick', y1_lim(1):y1_lim(2)/yticks:y1_lim(2));
set(ax(2),'YTick', y2_lim(1):y2_lim(2)/yticks:y2_lim(2));
% Legend
set(h2,'LineStyle','--');
set(h1,'LineWidth', 0.8);
set(h2,'LineWidth', 0.8);
lh = legend('Solved', 'Mean Solver Rate');
set(lh,'Location','East');
rotateXLabels(ax(1), 60);
grid on;
axes(ax(1)); ylabel('Solved [\%]');
axes(ax(2)); ylabel('Mean Solver Rate [Hz]');
xlabel('Maximum Increment per Iteration [rad]');

% Generate the tikz file
extra_opts = {'tick label style={font=\small}', 'label style={font=\small}', 'legend style={font=\small}'};
tikz_folder = [getuserdir() '/git/phd-thesis/tikz/'];

matlab2tikz([tikz_folder 'deco_step_size.tex'], 'standalone', true, 'showInfo',false,'height',...
        '50mm','width','120mm','floatFormat','%.4f');
