init_fieldtrip

data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\TimeFreqData';
fig_dest_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\TimeFreqPlots\SINC_ASINC';

subjs = [3 11 13 16 17 19];

all_sinc = [];
all_asi =[];
all_ind = 1;


% loop over subjects
for s=1:length(subjs)
    
    freq_subj_run = [];
    ind = 1;
    
    % loop over runs
    for r=1:2
        
        fname = sprintf( 'tf_tc_SUBJ%03i_RUN%i_Reref_Avg_ALL.mat', subjs(s), r ) ;
        
        freq_subj_run{ind} = load( fullfile( data_dir, fname ) )
        
        elec =  freq_subj_run{ind}.freq.elec;
        
        % SINC
        cfg = [];
        cfg.trials = find(freq_subj_run{ind}.freq.trialinfo == 10 | freq_subj_run{ind}.freq.trialinfo == 11 | freq_subj_run{ind}.freq.trialinfo == 20 ...
            | freq_subj_run{ind}.freq.trialinfo == 21 |  freq_subj_run{ind}.freq.trialinfo == 30 |   freq_subj_run{ind}.freq.trialinfo == 31)
        
        cfg.keeptrials = 'no';
        freq_subj_run_sinc{ind}.freq = ft_freqdescriptives(cfg, freq_subj_run{ind}.freq);
        
        % ASINC
        cfg = [];
        cfg.trials = find(freq_subj_run{ind}.freq.trialinfo == 12 | freq_subj_run{ind}.freq.trialinfo == 13 | freq_subj_run{ind}.freq.trialinfo == 22 ...
            | freq_subj_run{ind}.freq.trialinfo == 23 |  freq_subj_run{ind}.freq.trialinfo == 32 |   freq_subj_run{ind}.freq.trialinfo == 33)
        
        cfg.keeptrials = 'no';
        freq_subj_run_asi{ind}.freq = ft_freqdescriptives(cfg, freq_subj_run{ind}.freq);
        
        all_sinc{all_ind} = freq_subj_run_sinc{ind};
        all_asi{all_ind} = freq_subj_run_asi{ind};
        
        ind = ind + 1;
    end
    
    % SINC
    cfg = [];
    cfg.keepindividual = 'yes';
    str = 'ft_freqgrandaverage(cfg';
    for n=1:length(freq_subj_run_sinc)
        str = [str ', freq_subj_run_sinc{' num2str(n) '}.freq '];
    end
    str = [str ')'];
    [grandavg] = eval( str );
    
    freqs = [4 8; 8 13; 13 20];
    freqs = [1 4; 4 8; 8 13; 8 10; 10 13; 13 20];
    
    tit = sprintf( 'SINC SUBJ %s', num2str( subjs(s) ) );
    grandavg.elec = elec;
    plot_timefreq( grandavg, freqs, tit, fig_dest_dir )
    
    % ASINC
    cfg = [];
    cfg.keepindividual = 'yes';
    str = 'ft_freqgrandaverage(cfg';
    for n=1:length(freq_subj_run_asi)
        str = [str ', freq_subj_run_asi{' num2str(n) '}.freq '];
    end
    str = [str ')'];
    [grandavg] = eval( str );
    
    freqs = [4 8; 8 13; 13 20];
    freqs = [1 4; 4 8; 8 13; 8 10; 10 13; 13 20];
    
    tit = sprintf( 'ASINC SUBJ %s', num2str( subjs(s) ) );
    grandavg.elec = elec;
    plot_timefreq( grandavg, freqs, tit, fig_dest_dir )
    
    close all
    
end

% SINC
cfg = [];
cfg.keepindividual = 'yes';
str = 'ft_freqgrandaverage(cfg';
for n=1:length(all_sinc)
    str = [str ', all_sinc{' num2str(n) '}.freq '];
end
str = [str ')'];
[grandavg] = eval( str );

freqs = [4 8; 8 13; 13 20];
freqs = [1 4; 4 8; 8 13; 8 10; 10 13; 13 20];

tit = sprintf( 'SINC SUBJ %s', num2str( subjs(s) ) );
grandavg.elec = elec;
plot_timefreq( grandavg, freqs, tit, fig_dest_dir )

% ASINC
cfg = [];
cfg.keepindividual = 'yes';
str = 'ft_freqgrandaverage(cfg';
for n=1:length(all_asi)
    str = [str ', all_asi{' num2str(n) '}.freq '];
end
str = [str ')'];
[grandavg] = eval( str );

freqs = [4 8; 8 13; 13 20];
freqs = [1 4; 4 8; 8 13; 8 10; 10 13; 13 20];

tit = sprintf( 'ASINC SUBJ %s', num2str( subjs(s) ) );
grandavg.elec = elec;
plot_timefreq( grandavg, freqs, tit, fig_dest_dir )

close all
