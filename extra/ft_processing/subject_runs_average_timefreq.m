init_fieldtrip

data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\TimeFreqData';
fig_dest_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\TimeFreqPlots';

subjs = [3 11 13 16 17 19];

subjs = [17 19];

% loop over subjects
for s=1:length(subjs)
    
    freq_subj_run = [];
    ind = 1;
    
    % loop over runs
    for r=1:2
        
        fname = sprintf( 'tf_tc_SUBJ%03i_RUN%i_Reref_Avg_ALL.mat', subjs(s), r ) ;
        
        freq_subj_run{ind} = load( fullfile( data_dir, fname ) )
        
        elec =  freq_subj_run{ind}.freq.elec;
        
        cfg = [];
        cfg.keeptrials = 'no';
        freq_subj_run{ind}.freq = ft_freqdescriptives(cfg, freq_subj_run{ind}.freq);
        
        %         trial_groups = { { 'S 10', 'S 20', 'S 30', 'S 11', 'S 21', 'S 31' } , ...
        %             { 'S 12', 'S 22', 'S 32', 'S 13', 'S 23', 'S 33' } };
        %         group_names = {'SINC' , 'ASINC' };
        %
        %         for g=1:length( trial_groups )
        
        ind = ind + 1;
    end
    
    cfg = [];
    cfg.keepindividual = 'yes';
    str = 'ft_freqgrandaverage(cfg';
    for n=1:length(freq_subj_run)
        str = [str ', freq_subj_run{' num2str(n) '}.freq '];
    end
    str = [str ')'];
    [grandavg] = eval( str );
    
    freqs = [4 8; 8 13; 13 20];
    freqs = [1 4; 4 8; 8 13; 8 10; 10 13; 13 20];

    tit = sprintf( 'SUBJ %s', num2str( subjs(s) ) );
    
    grandavg.elec = elec;
    
    plot_timefreq( grandavg, freqs, tit, fig_dest_dir )
    
    close all
end
