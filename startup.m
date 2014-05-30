current_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd(path);
addpath(genpath(strcat(pwd, '/tools')));
cd(strcat(pwd, '/rvctools'));
startup_rvc;
cd(current_path);
clear;