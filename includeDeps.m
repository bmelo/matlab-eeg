addpath( fullfile(pwd, 'vendors/eeglab') );
addpath( fullfile(pwd, 'vendors/cosmomvpa') );
addpath( fullfile(pwd, 'src/utils') );

% Preparing eeglab
eeglab;
close all;

% Preparing CoSMoMVPA
cosmo_set_path;

addpath( fullfile(pwd, 'src', 'eeg') );
addpath( fullfile(pwd, 'src', 'eeg', 'stats') );