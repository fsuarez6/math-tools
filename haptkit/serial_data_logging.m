% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

clc; clear; close all;

DlgH = figure;
h = uicontrol('Style', 'PushButton', 'String', 'Break', 'Callback', 'delete(gcbf)');

s = serial('/dev/ttyUSB0');
set(s,'BaudRate',38400);
fopen(s);

i = 1;
while (ishandle(h))
  rawPos(i) = fscanf(s, '%d');
  updatedPos(i) = fscanf(s, '%d');
  pause(0.001);
  i = i + 1;
end

fclose(s);
delete(s);
