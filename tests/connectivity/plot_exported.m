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

indir = fullfile( config.outdir_base, 'FEATS' );
files = utils.resolve_names([indir '/*/l_*']);

for k=1:length(files)
    file = files{k};
    newfile = strrep(file, 'FEATS', 'FEATS/CON');
    basedir = fileparts(newfile);
    if ~isdir(basedir)
        mkdir(basedir);
    end
    copyfile(file, newfile);
end

chan_names = {EEG.chanlocs.labels};
% ---> PDC
figure('Name','Partial Directed Coherence (PDC)','NumberTitle','off');
plot_con_matrix(PDC, chan_names);
% ---> DTF
figure('Name','Directed Transfer Function (DTF)','NumberTitle','off'); % ---> DTF
plot_con_matrix(DTF, chan_names);