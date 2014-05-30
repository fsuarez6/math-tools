filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd(path);
addpath(genpath(strcat(pwd, '/functions')));
clear;