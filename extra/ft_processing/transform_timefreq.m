init_fieldtrip

data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz';
dest_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\TimeFreqPlots';
dest_dir_data = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\TimeFreqData_TR';

subjs = [3 11 13 16 17 19];
% subjs = [3];

% loop over subjects
for s=1:length(subjs)
    
    % loop over runs
    for r=1:2

%        fname = sprintf( 'tc_SUBJ%03i_RUN%i_Reref_Avg_ALL.mat', subjs(s), r ) ;
        fname = sprintf( 'tc_SUBJ%03i_RUN%i_Reref_Oz_ALL.mat', subjs(s), r ) ;

        load( fullfile( data_dir, fname ) );
            
        cfg = [];
        cfg.output         = 'pow';
        cfg.method         = 'mtmconvol';
        cfg.taper          = 'hanning';
        cfg.foi            = 1:100;
        cfg.t_ftimwin      = 2.45*ones(1,length(cfg.foi)); % window length: 2.5s
        cfg.toi            = -3.75 : 2.5 : 23.75;
        cfg.keeptrials     = 'yes';
        
        freq               = ft_freqanalysis(cfg, data);
        freq.elec          = data.elec;
        
        fns = sprintf( 'tf_%s.mat',fname(1:end-4) );
        
        if ~isdir( dest_dir_data ), mkdir( dest_dir_data ), end
        save( fullfile(dest_dir_data, fns) , 'freq' );
        
    end
end