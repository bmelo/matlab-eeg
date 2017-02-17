addpath( fullfile(pwd, 'vendors/eeglab') );
addpath( fullfile(pwd, 'src/utils') );

%to prepare eeglab
eeglab;
close all;

addpath( fullfile(pwd, 'eeg') );
addpath( fullfile(pwd, 'eeg', 'stats') );