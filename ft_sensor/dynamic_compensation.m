% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

clc; clear; close all;
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
pattern = '2015-02-24';
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
  time_ik = cellfun(@(msg) msg.header.stamp.time, msg_ik_command);
end
tilefigs;
