init_fieldtrip

%% config 1
% description of classifying data
data = [];

data.class(1).desc = 'MUSIC';
data.class(2).desc = 'RATING';

data.features.type = 'Powspctrm';

data.baseline.toi = [-5 0 ];

data.class(1).trialinfo = [10 11 12 13 20 21 22 23 30 31 32 33];
data.class(1).toi = [5 10];

data.class(2).trialinfo = [10 11 12 13 20 21 22 23 30 31 32 33];
data.class(2).toi = [20 25];

data_mean_trial = data;

subdir = 'TimeFreqData_TR';
subdir_classify = 'Music_Rating_TR_1_100Hz_Z';
transform_Z_per_run = 1;

% dirs
data_dir = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\', subdir);
data_classify = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\',subdir_classify,'\Freq\');

% subjects
subjs = [3 11 13 16 17 19];

freqs = [1 4; 4 8; 8 13; 8 10; 10 13; 13 20;20 30; 30 40; 40 50; 50 60; 60 70; 70 80; 80 90; 90 100];

build_x_y;


%% config 2: sem baseline
data = [];

data.class(1).desc = 'MUSIC';
data.class(2).desc = 'RATING';

data.features.type = 'Powspctrm';

data.baseline = [];

data.class(1).trialinfo = [10 11 12 13 20 21 22 23 30 31 32 33];
data.class(1).toi = [5 10];

data.class(2).trialinfo = [10 11 12 13 20 21 22 23 30 31 32 33];
data.class(2).toi = [20 25];

data_mean_trial = data;

%% subjects
subjs = [3 11 13 16 17 19];

build_x_y;
