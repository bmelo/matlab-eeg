init_fieldtrip

%% config 1
% description of classifying data
data = [];

data.desc = 'SUBJRATING';

data.features.type = 'Powspctrm';

data.baseline.toi = [-5 0 ];

data.trialinfo = [10 11 12 13 20 21 22 23 30 31 32 33];
data.toi = [0 20];

data_mean_trial = data;

subdir = 'TimeFreqData_TR';
subdir_classify = 'ClinicalBands_toi_0_20';

% dirs
data_dir = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\', subdir);
data_classify = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Regress\',subdir_classify,'\Freq\');

% subjects
subjs = [3 11 13 16 17 19];

freqs = [1 4; 4 8; 8 13; 13 30; 30 45; 45 60; 60 75; 75 90; 90 100];

build_x_y_rat;


%% config 2: sem baseline
% description of classifying data
data = [];

data.desc = 'SUBJRATING';

data.features.type = 'Powspctrm';

data.baseline = [];

data.trialinfo = [10 11 12 13 20 21 22 23 30 31 32 33];
data.toi = [0 20];

data_mean_trial = data;

subdir = 'TimeFreqData_TR';
subdir_classify = 'ClinicalBands_toi_0_20';

% dirs
data_dir = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\', subdir);
data_classify = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Regress\',subdir_classify,'\Freq\');

% subjects
subjs = [3 11 13 16 17 19];

freqs = [1 4; 4 8; 8 13; 13 30; 30 45; 45 60; 60 75; 75 90; 90 100];

build_x_y_rat;