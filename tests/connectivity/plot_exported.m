%% Setup of processing
config = setup('neutral_length', 10);
config.ignore = {
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

%% Listing all subjects
for subjN = config.subjs
    close all;
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    subjdir = fullfile( config.outdir_base, 'FEATS', subj );
    
    %% PDC
    load(fullfile(subjdir, 'l_pdc_feats'), 'EEG');
    pos_exclude = find([config.ignore{:,1}] == subjN);
    if pos_exclude
        rm_chs = config.ignore{pos_exclude, 2};
        EEG.N(rm_chs,:,:) = [];
        EEG.N(:,rm_chs,:) = [];
        EEG.T(rm_chs,:,:) = [];
        EEG.T(:,rm_chs,:) = [];
        EEG.A(rm_chs,:,:) = [];
        EEG.A(:,rm_chs,:) = [];
    end
    plot_con_matrix(EEG, config, [subj ' - PDC']);
    utils.imgs.print_fig( fullfile(subjdir, 'PDC.png') )
    
    %% DTF
    load(fullfile(subjdir, 'l_dtf_feats'), 'EEG');
    pos_exclude = find([config.ignore{:,1}] == subjN);
    if pos_exclude
        rm_chs = config.ignore{pos_exclude, 2};
        EEG.N(rm_chs,:,:) = [];
        EEG.N(:,rm_chs,:) = [];
        EEG.T(rm_chs,:,:) = [];
        EEG.T(:,rm_chs,:) = [];
        EEG.A(rm_chs,:,:) = [];
        EEG.A(:,rm_chs,:) = [];
    end
    plot_con_matrix(EEG, config, [subj ' - DTF']);
    utils.imgs.print_fig( fullfile(subjdir, 'DTF.png') )
end