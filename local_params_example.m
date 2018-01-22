config.vendors_dir = 'vendors';
config.srate = 250;

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
config.subjs = [1 2 4:15];
config.chs = 1:63;

config.neutral_length = 10;

config.visual_check = 1; % general purposes
config.compute_results = 1;
config.bands = [4 8; 8 13; 13 26; 26 45];

%% Proc SETUP
% Preproc steps
config.preproc.active = 0;
config.preproc.notch = 60;
config.preproc.filter = [1.5 50];
config.outlier_sd = 2;

% Proc steps
config.proc.features.active = 1;
config.proc.features.erders = 0;
config.proc.features.power = 0;
config.proc.features.power_rel = 0;
config.proc.features.eeg = 0;
config.proc.features.density = 0;
config.proc.features.connectivity = 1;

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
    15, [27]
};

config.features = {'l_power_rel_feats' 'l_erders_feats' 'l_dens_feats' 'l_con_feats'};
config.measures = {'median'};

config.cross.type = 'kfold';
config.cross.k = 8;
config.cross.repetitions = 15;

% For feature selection
config.channels = {
    % [4 8], {''}
    [8 13],  {'F3' 'F4' 'C3' 'C4' 'P3' 'P4' 'O1' 'O2' 'F7' 'F8' 'T7' 'T8' 'P7' 'P8' 'Fz' 'Cz' 'Pz' 'Oz' 'FC1' 'FC2' 'CP1' 'CP2' 'FC5' 'FC6' 'CP5' 'CP6' 'TP9' 'TP10' 'POz' 'F1' 'F2' 'C1' 'C2' 'P1' 'P2' 'AF3' 'AF4' 'FC3' 'FC4' 'CP3' 'CP4' 'PO3' 'PO4' 'F5' 'F6' 'C5' 'C6' 'P5' 'P6' 'FT7' 'FT8' 'TP7' 'TP8' 'PO7' 'PO8' 'FT9' 'FT10' 'CPz'}
    [13 30], {'P3' 'O1' 'O2' 'T7' 'T8' 'P7' 'P8' 'Pz' 'Oz' 'TP9' 'POz' 'P1' 'PO3' 'PO4' 'P5' 'P6' 'TP7' 'TP8' 'PO7' 'PO8' 'FT9' 'CPz'}
    [30 45], {'FT9' 'FT10'}
};

% Setup for ANN
config.ann.featselection = 0;
config.ann.random_classes = 0;
config.ann.show_window = 1;
config.ann.max_fail = 10;
config.ann.hidden = 2;

% For debugging
config.debug = 1;
if config.debug
    config.subjs = [1 2];
    config.bands = [4 8; 8 13; 13 30; 30 45];
    
    config.features = {'l_power_rel_feats' 'l_pdc_conn'};
    %config.chs = [9 10 20 31 44 45 54 59];
end