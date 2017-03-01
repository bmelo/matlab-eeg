init_fieldtrip

data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT';
dest_dir_data = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\TimeFreqData_win1s';

subjs = [3 11 13 16 17 19];
% subjs = [3];

% loop over subjects
for s=1:length(subjs)
    
    % loop over runs
    for r=1:2

        fname = sprintf( 'tc_SUBJ%03i_RUN%i_Reref_Avg_ALL.mat', subjs(s), r ) ;

        load( fullfile( data_dir, fname ) );
            
        cfg = [];
        cfg.output         = 'pow';
        cfg.method         = 'mtmconvol';
        cfg.taper          = 'hanning';
        cfg.foi            = 1:30;
        cfg.t_ftimwin      = 1*ones(1,length(cfg.foi)); % window length: 2.5s
        cfg.toi            = -5:1:25;
        cfg.keeptrials     = 'yes';
        
        freq               = ft_freqanalysis(cfg, data);
        freq.elec          = trialdata.elec;
        
        fns = sprintf( 'tf_%s.mat',fname(1:end-4) );
        
        save( fullfile(dest_dir_data, fns) , 'freq' );
        
    end
end