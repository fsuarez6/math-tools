current_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd(path);
% Add custom scripts
addpath(genpath(strcat(pwd, '/tools')));
% Add tikz functionality to matlab
cd('../matlab2tikz');
addpath(genpath(strcat(pwd, '/src')));
% Add rosbag functionality to matlab
cd('../matlab_rosbag');
addpath(genpath(strcat(pwd, '/src')));
% Add YAML support
cd(current_path);
addpath(genpath(strcat(pwd, '/YAMLMatlab_0.4.3')));
% Add image measuretool support
cd(current_path);
addpath(genpath(strcat(pwd, '/measuretool-1.14')));
% Add image ArduinoIO support
cd(current_path);
addpath(genpath(strcat(pwd, '/ArduinoIO')));
% Add robotic toolbox to the path
if ~is_octave
  cd(strcat(current_path, '/rvctools'));
  startup_rvc;
end
cd(current_path);
