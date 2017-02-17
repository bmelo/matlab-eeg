addpath( fullfile(pwd, '../vendor/eeglab13_5_4b') );
addpath( fullfile(pwd, 'utils') );

%to prepare eeglab
eeglab;
close all;

addpath( fullfile(pwd, 'eeg') );
addpath( fullfile(pwd, 'eeg', 'stats') );