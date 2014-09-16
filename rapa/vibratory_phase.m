% Run the startup script
script_path = pwd;
filename = mfilename('fullpath');
[path, name, ext] = fileparts(filename);
cd('../');
startup;
cd(script_path);

clear; close all;

%~ vibration:
  %~ a: 2.0
  %~ c: 5.0
  %~ frequency: 30.0
  %~ duration: 0.3

t = 0:1e-3:0.3;
w = 2*pi*30;
A = 2;
C = 5;
F = A * exp(-C .* t) .* sin(w * t);

set(0,'defaulttextinterpreter','latex');
figure,
plot(t * 1000, F);
grid on;
ylabel('Vibration Force [N]');
xlabel('Time [ms.]');
xlim([min(t) max(t)] * 1000);
legend('$F_{vib} = A e^{-C t}\sin{\left( 2\pi f t \right)}$');

% Generate the tikz file
tikz_folder = [getuserdir() '/git/phd-thesis/tikz/'];

matlab2tikz([tikz_folder 'rapa_vibratory_phase.tex'], 'standalone', true, 'showInfo',false,'height',...
        '50mm','width','80mm','floatFormat','%.4f');
