init_fieldtrip

data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\TimeFreqData';
fig_dest_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\TimeFreqPlots';

subjs = [3 11 13 16 17 19];

% loop over subjects
for s=1:length(subjs)
    
    % loop over runs
    for r=1:2

        fname = sprintf( 'tf_tc_SUBJ%03i_RUN%i_Reref_Avg_ALL.mat', subjs(s), r ) ;
       
        load( fullfile( data_dir, fname ) )
        
        %         trial_groups = { { 'S 10', 'S 20', 'S 30', 'S 11', 'S 21', 'S 31' } , ...
        %             { 'S 12', 'S 22', 'S 32', 'S 13', 'S 23', 'S 33' } };
        %         group_names = {'SINC' , 'ASINC' };
        %
        %         for g=1:length( trial_groups )
        
        freqs = [4 8; 8 13; 13 20];
        tit = sprintf( 'SUBJ%03i RUN%i', subjs(s), r ) ;
        
        % plot_timefreq( freq, freqs, tit, fig_dest_dir )
        
        plot_timefreq_pertrial( freq, freqs, tit, fig_dest_dir )
        
        close all;
        
        %         end
        
    end
end