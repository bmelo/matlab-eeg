init_fieldtrip

data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT';
dest_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\TimeFreqPlots';
dest_dir_data = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\TimeFreqData';

subjs = [3 11 13 16 17 19];

% loop over subjects
for s=1:length(subjs)
    
    % loop over runs
    for r=1:2
        
        fname = sprintf( 'SUBJ%03i_RUN%i_Reref_Avg.set', subjs(s), r ) ;
        
        cfg = [];
        cfg.dataset = fullfile( data_dir, fname );
        data = ft_preprocessing(cfg);	% call preprocessing
        
        [cfg data_no_artifacts] = samba_artifact_removal( cfg, data );
                
        save( fullfile( data_dir, ['c' fname(1:end-4) '.mat']), 'data_no_artifacts' );
        
    end
end