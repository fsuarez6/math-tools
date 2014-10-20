% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

clc; clear; close all;
home_path = getuserdir();
data_folder = [getuserdir() '/journal_data/'];
methods = {'kdl','lma','decoup'};
labels = {'Iterative Decoupling', 'Levenberg--Marquardt', 'Newton--Raphson'};
% Get the files that include the pattern
pattern = '_iter_';
extension = '.mat';
filenames = get_files_by_pattern(data_folder, ['*' extension], pattern);
solved_count = ones(length(methods), 1);
loop_count = ones(length(methods), 1);

for f = 1:length(filenames)
  for m = 1:length(methods)
    filename = filenames{f};
    method = methods{m};
    if isempty(strfind(filename, method))
      continue
    end
    load([data_folder filename]);
    idx = iterations > 0;
    n = sscanf(filename, [method pattern '%d' extension]);
    results(m).iterations(loop_count(m)) = n(1);
    loop_count(m) = loop_count(m) + 1;
    mean_time = mean(time(idx));
    if isnan(mean_time)
      continue;
    end
    results(m).iter_number(solved_count(m)) = n(1);
    results(m).mean_time(solved_count(m)) = mean_time;
    results(m).median_time(solved_count(m)) = median(time(idx));
    results(m).solved(solved_count(m)) = 100 * sum(idx) / length(iterations);
    solved_count(m) = solved_count(m) + 1;
  end
end
sorted_iterations = sort(results(1).iterations);

for m = 1:length(methods)
  [method_iter, sorted_idx] = sort(results(m).iter_number);
  plots_data(m).y = results(m).solved(sorted_idx);
  for i = 1:length(results(m).iter_number)
    plots_data(m).x(i) = find(method_iter(i)==sorted_iterations);
  end
end

ColorSet = distinguishable_colors(3);
set(0,'DefaultAxesColorOrder', ColorSet);
set(0,'defaulttextinterpreter','latex');

% Plot
figure; hold on; grid on; box on;
plot(plots_data(3).x, plots_data(3).y, '-rs', 'LineWidth', 0.8);
plot(plots_data(2).x, plots_data(2).y, '--gd', 'LineWidth', 0.8);
plot(plots_data(1).x, plots_data(1).y, ':bo', 'LineWidth', 0.8);
lh = legend(labels);
set(lh, 'Location', 'NorthWest');
xlim([0 25]);
set(gca,'XTick', 1:24);
set(gca,'XTickLabel', sorted_iterations);
xh = get(gca,'XLabel');
set(xh,'Position',get(xh,'Position') - [0 .2 0]);
rotateXLabels(gca, 60);
set(gca,'YTick', 0:10:100);
xlabel('Number of Iterations');
ylabel('Solved [\%]');
% Generate the tikz file
extra_opts = {'tick label style={font=\footnotesize}', 'label style={font=\small}', 'legend style={font=\footnotesize}'};
tikz_folder = [getuserdir() '/git/phd-thesis/tikz/'];

matlab2tikz([tikz_folder 'deco_iterations.tex'], 'standalone', true, 'showInfo',false,'height',...
        '50mm','width','120mm','floatFormat','%.4f','extraAxisOptions',extra_opts);
