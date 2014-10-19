% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

clear; close all;
home_path = getuserdir();
data_folder = [getuserdir() '/journal_data/'];
methods = {'kdl','lma','decoup'};
labels = {'N--R','L--M','I--D'};
% Get the files that include the pattern
pattern = '_iter_';
extension = '.mat';
filenames = get_files_by_pattern(data_folder, ['*' extension], pattern);
count = ones(length(methods), 1);

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
    mean_time = mean(time(idx));
    if isnan(mean_time)
      continue;
    end
    results(m).iter_number(count(m)) = n(1);
    results(m).mean_time(count(m)) = mean_time;
    results(m).median_time(count(m)) = median(time(idx));
    results(m).solved(count(m)) = 100 * sum(idx) / length(iterations);
    count(m) = count(m) + 1;
  end
end

ColorSet = distinguishable_colors(3);
set(0,'DefaultAxesColorOrder', ColorSet);
set(0,'defaulttextinterpreter','latex');

% KDL
[kdl_iter, idx] = sort(results(1).iter_number);
kdl_solved = results(1).solved(idx);
disp(idx)
% LMA
[lma_iter, idx] = sort(results(2).iter_number);
lma_solved = results(2).solved(idx);
disp(idx)
% Decoupling
[deco_iter, idx] = sort(results(3).iter_number);
deco_solved = results(3).solved(idx);
disp(idx)

% Plot
figure; hold on; grid on;
plot(deco_iter, deco_solved, ':rs', 'LineWidth', 0.8);
plot(kdl_iter, kdl_solved, '-gd', 'LineWidth', 0.8);
plot(lma_iter, lma_solved, '--bo', 'LineWidth', 0.8);

%~ set(gca,'XTick', );
%~ set(gca,'XTickLabel', step_size);
tilefigs;
