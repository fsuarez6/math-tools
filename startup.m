current_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd(path);
addpath(genpath(strcat(pwd, '/tools')));
cd('../matlab2tikz');
addpath(genpath(strcat(pwd, '/src')));
if ~is_octave
  cd(strcat(current_path, '/rvctools'));
  startup_rvc;
end
cd(current_path);
