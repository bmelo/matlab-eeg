init_fieldtrip

dest_dir_data = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\simulated';

data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT';
fname = 'SUBJ003_RUN1_Reref_Avg.set';

ds = fullfile( data_dir, fname );
cut = 40;
sliding_win = 0.5;

[cfg_complete artifact data] = get_std_artifacts( ds, cut, sliding_win );

trial_groups = { { 'S 10', 'S 20', 'S 30', 'S 11', 'S 21', 'S 31', ...
    'S 12', 'S 22', 'S 32', 'S 13', 'S 23', 'S 33' } };

group_names = { 'ALL' };

simulated_data = fun_simulate_data( data, trial_groups );


for g=1:length( trial_groups )
    
    cfg = cfg_complete;
    cfg.trialdef.prestim  = 5;                 % in seconds
    cfg.trialdef.poststim = 25;
    cfg.trialdef.eventtype = 'trigger';           % use ‘?’ to get a list of the available types
    cfg.trialdef.eventvalue = trial_groups{g};
    
    % redefine data set in order to find header file
    cfg.dataset = fullfile( data_dir, fname );
    
    % create trial definition structure
    cfg = ft_definetrial(cfg)
    
    % extract trial data
    trialdata = ft_redefinetrial(cfg, simulated_data);
    
    % reject artifacts
    data = ft_rejectartifact( cfg, trialdata );
    
    fns = sprintf( 'tc_simulated.mat',fname(1:end-4), group_names{g} );
    
    save( fullfile(dest_dir_data, fns) , 'data' );
    
end
