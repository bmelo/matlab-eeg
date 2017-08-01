config.vendors_dir = 'vendors';
config.debug = 0;

if isunix
    config.rawdir_base = '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/RAW_DATA/EEG';
    config.preproc_dir = '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/PREPROC_DATA/EEG/MATLAB';
    config.outdir_base = '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/PROC_DATA/EEG';
    config.imgsexport_dir = '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/PROC_DATA/EEG';
else
    config.rawdir_base = '../../../RAW_DATA/EEG';
    config.outdir_base = '../../../PROC_DATA/EEG';
end
config.subj_prefix = 'SUBJ';
config.subjs = 1:14;
config.chs = 1:63;

config.srate = 500;

config.neutral_length = 10;

config.visual_check = 1; % general purposes
config.compute_results = 1;
config.bands = [8 13; 13 26; 26 45];

%% Proc SETUP
% Preproc steps
config.preproc.active = 0;

% Proc steps
config.proc.features.active = 0;
config.proc.features.erders = 1;
config.proc.features.density = 1;
config.proc.grand_average = 1;
config.proc.gavg_prefix = {'p'};

% Statistics
config.stats.first_level = 1;
config.stats.second_level = 1;

%% Classification
config.force_features = 1;

% For debugging
if config.debug
    config.subjs = 4;
    config.chs = [9 10 20 31 44 45 54 59];
end