current_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd(path);
% Add custom tool scripts
addpath(genpath(strcat(pwd, '/tools')));
% Add tikz functionality to matlab
cd('../matlab2tikz');
addpath(genpath(strcat(pwd, '/src')));
% Add rosbag functionality to matlab
cd('../matlab_rosbag');
addpath(genpath(strcat(pwd, '/src')));
% Add robotic toolbox to the path
if ~is_octave
  cd(strcat(current_path, '/rvctools'));
  startup_rvc;
end
cd(current_path);
