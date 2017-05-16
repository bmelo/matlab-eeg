function run_eeg()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;
clc;

%% Setup of processing
config = setup('neutral_length', 10);

% Configuring Grand Average
config.prefix = 'p';
%config.gavg_files = {'pEEG_global', {'pEEG_8_13' 'pEEG_13_26' 'pEEG_26_45'}};
%config.gavg_files = {{'pEEG_8_13' 'pEEG_13_26' 'pEEG_26_45'}};
%config.gavg_files = {'pEEG_global'};
config.gavg_files = {'pEEG_global', {'pEEG_8_13' 'pEEG_13_26' 'pEEG_26_45'}};
config.gavg_filter = @erd_ers;
config.gavg_filter_params = {};

config.ignore = {
    1,  [48]
    2,  [18 48]
    3,  [49]
    4,  [9 10 20 31 44 45 54 59]
    5,  [31 34]
    6,  [32 41 63]
    9,  [48]
    10, [13 59]
    13, [27]
    14, [29 56]
};

% Executing according to config variable
run_procs(config);

%{
Canais com problema:

SUBJ001 - C5
SUBJ002 - C5, Cz
SUBJ003 - C6
SUBJ004 - O1,O2,Oz,PO2,PO3,PO4,PO8,FT7
SUBJ005 - C1,POz*
SUBJ006 - CPz, F1, FC4*
SUBJ007 - nada
SUBJ008 - nada
SUBJ009 - C5*
SUBJ010 - T7*, PO8*
SUBJ011 - nada
SUBJ012 - nada
SUBJ013 - CP5*
SUBJ014 - TP9, TP7

* canais que começaram bem, mas ficaram ruins no decorrer da tarefa
%}