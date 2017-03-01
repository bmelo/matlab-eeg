%init_fieldtrip

data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT';

subjs = [3 11 13 16 17 19];

freqs = [1 4; 4 8; 8 13; 8 10; 10 13; 13 30; 17.5 18.5];
freq_names = { 'delta', 'theta', 'alpha', 'low_alpha', 'high_alpha', 'beta', '18' };

ind = 1;
% loop over subjects
for s=1:length(subjs)
    
    % loop over runs
    for r=1:2

         fname = sprintf( 'tc_SUBJ%03i_RUN%i_Reref_Avg_ALL.mat', subjs(s), r ) ;
        
         load( fullfile( data_dir, fname ) )

         data_orig = data;
         
         for b = 1:length(freqs)
             Fsample = data.fsample;
             Fbp = freqs(b,:);
             N = 4;
             type = 'but';
             
             for tr=1:length(data_orig.trial)
                 data.trial{tr} = ft_preproc_bandpassfilter( data_orig.trial{tr}, Fsample, Fbp, N, type );
             end
             
             data.info = freq_names{b};
             
             dest_dir = fullfile( data_dir, freq_names{b} );
             if ~isdir( dest_dir ), mkdir( dest_dir ), end;
             
             save( fullfile( dest_dir, [freq_names{b} '_' fname]), 'data' )
         end
    end
    
end