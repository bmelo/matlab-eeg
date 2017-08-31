indir  = 'E:\Users\Bruno\Documentos\projetos\doutorado\DATA\PREPROC_DATA/';
outdir = 'E:\Users\Bruno\Documentos\projetos\doutorado\DATA\PROC_DATA\FEATS/';

files = utils.resolve_names( [outdir, 'SUBJ*/dens*'] );
for nF = 1:length(files)
    file = files{nF};
    subjid = regexp(file, 'SUBJ\d+', 'match', 'once');
    
    %filename = utils.path.basename(file);
    subjdir = fullfile(outdir, subjid);
    outfile = strrep(file, 'densEEG_', '');
    outfile = strrep(outfile, '.mat',  '_dens_feats.mat');
    
    fprintf('%s -> %s\n', file, outfile);
    movefile( file, outfile );
end