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

for m = 1:length(methods)
  [x, idx] = sort(results(m).iter_number);
  x = 1:length(idx);
  y1 = results(m).solved(idx);
  y2 = results(m).mean_time(idx) .^ (-1);
  figure,
  plotyy(x, y1, x, y2);
  %~ bar(y1);
  %~ axis equal;
end

tilefigs;
