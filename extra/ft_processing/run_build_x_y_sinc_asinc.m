init_fieldtrip

%% config 1: com baseline
data = [];

% description of classifying data
data.class(1).desc = 'SINC';
data.class(2).desc = 'ASINC';

data.features.type = 'Powspctrm';

toi = [0 20];
data.class(1).trialinfo = [10 11 20 21 30 31 ];
data.class(1).toi = toi;

data.class(2).trialinfo = [12 13 22 23 32 33];
data.class(2).toi = toi;

data.baseline.toi = [-5 0 ];

data_mean_trial = data;

subdir = 'TimeFreqData_TR';
subdir_classify = 'Sinc_Asinc_TR_1_100Hz_toi_0_20_Z';
transform_Z_per_run = 1;

% dirs
data_dir = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\', subdir);
data_classify = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\',subdir_classify,'\Freq\');

% subjects
subjs = [3 11 13 16 17 19];

freqs = [1 4; 4 8; 8 13; 8 10; 10 13; 13 20;20 30; 30 40; 40 50; 50 60; 60 70; 70 80; 80 90; 90 100];

build_x_y


%% config2: sem baseline
data = [];

% description of classifying data
data.class(1).desc = 'SINC';
data.class(2).desc = 'ASINC';

data.features.type = 'Powspctrm';

data.class(1).trialinfo = [10 11 20 21 30 31 ];
data.class(1).toi = toi;

data.class(2).trialinfo = [12 13 22 23 32 33];
data.class(2).toi = toi;

data.baseline = [];

data_mean_trial = data;

% dirs
data_dir = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\', subdir);
data_classify = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\',subdir_classify,'\Freq\');

% subjects
subjs = [3 11 13 16 17 19];

build_x_y

%% config 3: embaralhado
data = [];

% description of classifying data
data.class(1).desc = 'SINC';
data.class(2).desc = 'ASINC';

data.features.type = 'Powspctrm';

data.class(1).trialinfo = [10 13 20 23 30 33 ];
data.class(1).toi = toi;

data.class(2).trialinfo = [11 12 21 22 31 32];
data.class(2).toi = toi;

data.baseline.toi = [-5 0 ];

data_mean_trial = data;

% dirs
data_dir = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\', subdir);
data_classify = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\',subdir_classify,'\Freq_Embaralhado\');

% subjects
subjs = [3 11 13 16 17 19];

build_x_y


%% config 4: embaralhado sem baseline
data = [];

% description of classifying data
data.class(1).desc = 'SINC';
data.class(2).desc = 'ASINC';

data.features.type = 'Powspctrm';

data.class(1).trialinfo = [10 13 20 23 30 33 ];
data.class(1).toi = toi;

data.class(2).trialinfo = [11 12 21 22 31 32];
data.class(2).toi = toi;

data.baseline = [];

data_mean_trial = data;

% dirs
data_dir = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\', subdir);
data_classify = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\',subdir_classify,'\Freq_Embaralhado\');

% subjects
subjs = [3 11 13 16 17 19];

build_x_y




%% config 5: embaralhado 2
data = [];

% description of classifying data
data.class(1).desc = 'SINC';
data.class(2).desc = 'ASINC';

data.features.type = 'Powspctrm';

data.class(1).trialinfo = [10 12 21 23 30 32 ];
data.class(1).toi = toi;

data.class(2).trialinfo = [11 13 20 22 31 33];
data.class(2).toi = toi;

data.baseline.toi = [-5 0 ];

data_mean_trial = data;

% dirs
data_dir = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\', subdir);
data_classify = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\',subdir_classify,'\Freq_Embaralhado2\');

% subjects
subjs = [3 11 13 16 17 19];

build_x_y
