% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

clc; clear; close all;
% Check that the grips metapackage exists
grips_dir = [getuserdir() '/catkin_ws/src/grips/'];
if exist(grips_dir, 'dir') ~= 7
  error('grips metapackage not found')
end

% Create the trajectory using the lemniscate function: http://mathworld.wolfram.com/Lemniscate.html
points = 200;
t = 0:2*pi/(points-1):2*pi;
a = 0.25;
den = 1 + sin(t).^2;
x = a.*cos(t)./ den;
z = 0.5 + a.*sin(t).*cos(t) ./ den;
%~ plot(x, z);
y = ones(1,points) * 0.9;
xw = ones(1,points)' * sqrt(2) / 2;
q = [-xw zeros(2,points)' xw];

% Poses are stored as:
% rotation     position
% [w x y z]    [x y z]
data.time_step = 10 / points;     % Seconds
data.frame_id = 'base_link';
data.points = [q x' y' z'];
WriteYaml([grips_dir '/grips_teleop/config/lemniscate_trajectory.yaml'],data);
