config.vendors_dir = 'vendors';
config.srate = 500;

sratedir = sprintf('%dHZ', config.srate);
if isunix
    basedir = '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS';
    config.rawdir_base    = fullfile(basedir, 'RAW_DATA/EEG');
    config.preproc_dir    = fullfile(basedir, 'PREPROC_DATA/EEG/MATLAB');
    config.outdir_base    = fullfile(basedir, 'PROC_DATA/EEG', sratedir);
    config.imgsexport_dir = fullfile(basedir, 'PROC_DATA/EEG', sratedir, 'IMGS');
else
    config.rawdir_base = '../../../RAW_DATA/EEG';
    config.outdir_base = '../../../PROC_DATA/EEG';
end
config.subj_prefix = 'SUBJ';
config.subjs = 1:14;
config.chs = 1:63;

config.neutral_length = 10;

config.visual_check = 1; % general purposes
config.compute_results = 1;
config.bands = [8 13; 13 26; 26 45];

%% Proc SETUP
% Preproc steps
config.preproc.active = 1;
config.preproc.notch = 60;
config.preproc.filter = [6 48];

% Proc steps
config.proc.features.active = 1;
config.proc.features.erders = 0;
config.proc.features.power = 0;
config.proc.features.power_rel = 1;
config.proc.features.eeg = 0;
config.proc.features.density = 0;

config.proc.grand_average = 0;
config.proc.gavg_prefix = {'p'};

% Statistics
config.stats.first_level = 0;
config.stats.second_level = 0;

%% Classification
config.ignore = {
     % Apply in all
     %0, [1 2 13 14 15 16 26 30 38 49 52 55 56 57 59 61]
     % Subjects specific channel remotion
     1, [48]
     2, [18 48]
     3, [49]
     4, [9 10 20 31 44 45 54 59]
     5, [31 34]
     6, [32 41 63]
     9, [48]
    10, [13 59]
    13, [27]
    14, [29 56]
};

config.features = {'power_rel_feats' 'erders_feats' 'dens_feats'};
config.measures = {'median'};

config.cross.type = 'kfold';
config.cross.k = 16;
config.cross.repetitions = 5;

% For feature selection
config.channels = {
    [8 13],  {'F3' 'F4' 'C3' 'C4' 'P3' 'P4' 'O1' 'O2' 'F7' 'F8' 'T7' 'T8' 'P7' 'P8' 'Fz' 'Cz' 'Pz' 'Oz' 'FC1' 'FC2' 'CP1' 'CP2' 'FC5' 'FC6' 'CP5' 'CP6' 'TP9' 'TP10' 'POz' 'F1' 'F2' 'C1' 'C2' 'P1' 'P2' 'AF3' 'AF4' 'FC3' 'FC4' 'CP3' 'CP4' 'PO3' 'PO4' 'F5' 'F6' 'C5' 'C6' 'P5' 'P6' 'FT7' 'FT8' 'TP7' 'TP8' 'PO7' 'PO8' 'FT9' 'FT10' 'CPz'}
    [13 26], {'P3' 'O1' 'O2' 'T7' 'T8' 'P7' 'P8' 'Pz' 'Oz' 'TP9' 'POz' 'P1' 'PO3' 'PO4' 'P5' 'P6' 'TP7' 'TP8' 'PO7' 'PO8' 'FT9' 'CPz'}
    [26 45], {'FT9' 'FT10'}
};
config.featselection = 0;
config.random_classes = 0;
config.show_window = 0;
config.max_fail = 10;

% For debugging
config.debug = 0;
if config.debug
    config.subjs = [2 3];
    config.bands = [8 13; 13 26];
    %config.chs = [9 10 20 31 44 45 54 59];
end