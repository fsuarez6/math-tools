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
pattern = '2015-02-13';
extension = '*.bag';
filenames = get_files_by_pattern(data_folder, extension, pattern);
for f = 1:length(filenames)
%~ for f = 1:1
  filename = filenames{f};
  disp(filename);
  bag = ros.Bag.load([data_folder filename]);
  msgs = bag.readAll({'/netft/data'});
  % Convert structure to 3-by-N matrix
  force = ros.msgs2mat(msgs, @(msg) msg.wrench.force);
  % Get timestamps
  times = cellfun(@(msg) msg.header.stamp.time, msgs);
  times = times - min(times);  
  % Calculate the FFT
  Fs = 1000;                    % Sampling frequency
  T = 1/Fs;                     % Sample time
  L = length(times);            % Length of signal
  NFFT = 2^nextpow2(L); % Next power of 2 from length of y
  Fz = force(3,:);
  FFTz = fft(Fz - mean(Fz), NFFT)/L;
  freq = Fs/2*linspace(0,1,NFFT/2+1);
  % Plot single-sided amplitude spectrum.
  figure, plot(freq,2*abs(FFTz(1:NFFT/2+1))) 
  title('Single-Sided Amplitude Spectrum of F_z')
  xlabel('Frequency (Hz)')
  ylabel('|F_z (N)|')
  % Stopband Butterworth filter
  nyq = 0.5 * Fs;
  [b,a] = butter(6, [30 70]/nyq, 'stop');
  Fz_filtered = filter(b, a, Fz);
  % Lowpass Butterworth filter
  [b,a] = butter(2, 30/nyq, 'low');
  Fz_filtered_low = filter(b, a, Fz);
  % Plot results
  figure, plot(times, [Fz' Fz_filtered' Fz_filtered_low']);
  title('Bandstop Filter');
  legend({'F_z measured', 'Stopband', 'Lowpass'});  
end
tilefigs;
