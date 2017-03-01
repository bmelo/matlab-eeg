init_fieldtrip

data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT';

subjs = [3 11 13 16 17 19];

fns = [];
percentrejected = [];

% loop over subjects
for s=1:length(subjs)
    
    % loop over runs
    for r=1:2

        fname = sprintf( 'tc_SUBJ%03i_RUN%i_Reref_Avg_ALL.mat', subjs(s), r ) ;
       
        load( fullfile( data_dir, fname ) )
        
        fns{end+1} = fname;
        
        percentrejected(end+1) = data.cfg.previous.previous.artfctdef.threshold.percentrejected;
        
    end
end