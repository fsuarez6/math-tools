% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

% Here goes the magic
clc; clear; close all;
home_dir = getuserdir();
home_space = [home_dir '/takktile_data/'];
if exist(home_space, 'dir') == 7
  data_folder = home_space;
else
  error('experiments folder not found')
end
pattern = 'calibration';
extension = '*.mat';

filenames = get_files_by_pattern(data_folder, extension, pattern);

for f = 1:length(filenames)
  filename = filenames{f};
  load([data_folder filename]);
  time = time - min(time);
  wrench_offset = wrench(1,:);
  for row = 1:length(wrench)
    wrench(row, :) = wrench(row, :) - wrench_offset;
  end
  figure, plot(wrench(:,1:3));
  grid on;
  figure, plot(pressure);
  grid on;
  disp([filename ': ' num2str(time(end), '%.2f') ' seconds.']);
end
