addpath( fullfile(pwd, 'vendors/eeglab') );
addpath( fullfile(pwd, 'src/utils') );

%to prepare eeglab
eeglab;
close all;

addpath( fullfile(pwd, 'src', 'eeg') );
addpath( fullfile(pwd, 'src', 'eeg', 'stats') );