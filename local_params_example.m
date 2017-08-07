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
config.proc.features.erders = 1;
config.proc.features.density = 1;
config.proc.grand_average = 0;
config.proc.gavg_prefix = {'p'};

% Statistics
config.stats.first_level = 0;
config.stats.second_level = 0;

%% Classification
config.force_features = 1;

% For debugging
config.debug = 0;
if config.debug
    config.subjs = [2 3];
    config.bands = [8 13; 13 26];
    %config.chs = [9 10 20 31 44 45 54 59];
end