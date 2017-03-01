init_fieldtrip

%% config 1: com baseline
data = [];

% description of classifying data
desc1 = 'As0';
desc2 = 'As83';
data.class(1).desc = desc1;
data.class(2).desc = desc2;

data.features.type = 'Powspctrm';

toi = [0 20];
trialinfo1 = [10 20 30 ];
trialinfo2 = [13 23 33];

data.class(1).trialinfo = trialinfo1; 
data.class(1).toi = toi;

data.class(2).trialinfo = trialinfo2;
data.class(2).toi = toi;

data.baseline.toi = [-5 0 ];

data_mean_trial = data;

subdir = 'TimeFreqData_TR';
subdir_classify = 'As0_As83_TR_1_100Hz_toi_0_20';

% dirs
data_dir = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\', subdir);
data_classify = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir_classify,'\Freq\');

% subjects
subjs = [3 11 13 16 17 19];

freqs = [1 4; 4 8; 8 13; 8 10; 10 13; 13 20;20 30; 30 40; 40 50; 50 60; 60 70; 70 80; 80 90; 90 100];

build_x_y


%% config2: sem baseline
data = [];

% description of classifying data
data.class(1).desc = desc1;
data.class(2).desc = desc2;

data.features.type = 'Powspctrm';

data.class(1).trialinfo = trialinfo1; 
data.class(1).toi = toi;

data.class(2).trialinfo = trialinfo2;
data.class(2).toi = toi;

data.baseline = [];

data_mean_trial = data;

% dirs
data_dir = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\', subdir);
data_classify = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir_classify,'\Freq\');

% subjects
subjs = [3 11 13 16 17 19];

build_x_y

%% config 3: embaralhado
data = [];

% description of classifying data
data.class(1).desc = desc1;
data.class(2).desc = desc2;

data.features.type = 'Powspctrm';

data.class(1).trialinfo = trialinfo1; 
data.class(1).toi = toi;

data.class(2).trialinfo = trialinfo2;
data.class(2).toi = toi;

data.baseline.toi = [-5 0 ];

data_mean_trial = data;

% dirs
data_dir = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\', subdir);
data_classify = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir_classify,'\Freq_Embaralhado\');

% subjects
subjs = [3 11 13 16 17 19];

build_x_y


%% config 4: embaralhado sem baseline
data = [];

% description of classifying data
data.class(1).desc = desc1;
data.class(2).desc = desc2;

data.features.type = 'Powspctrm';

data.class(1).trialinfo = trialinfo1; 
data.class(1).toi = toi;

data.class(2).trialinfo = trialinfo2;
data.class(2).toi = toi;

data.baseline = [];

data_mean_trial = data;

% dirs
data_dir = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\', subdir);
data_classify = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir_classify,'\Freq_Embaralhado\');

% subjects
subjs = [3 11 13 16 17 19];

build_x_y




%% config 5: embaralhado 2
data = [];

% description of classifying data
data.class(1).desc = desc1;
data.class(2).desc = desc2;

data.features.type = 'Powspctrm';

data.class(1).trialinfo = trialinfo1; 
data.class(1).toi = toi;

data.class(2).trialinfo = trialinfo2;
data.class(2).toi = toi;

data.baseline.toi = [-5 0 ];

data_mean_trial = data;

% dirs
data_dir = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\', subdir);
data_classify = fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir_classify,'\Freq_Embaralhado2\');

% subjects
subjs = [3 11 13 16 17 19];

build_x_y
