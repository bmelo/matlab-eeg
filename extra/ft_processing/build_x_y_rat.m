
ons_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\data_analysis_logfiles\ana_RM\ons';

% loop over subjects
for s=1:length(subjs)
    
    freq_subj_run = [];
    ind = 1;
    
    ons = load( fullfile( ons_dir, sprintf( 'SUBJ%03i.mat', subjs(s)) ) );
    
    % loop over runs
    for r=1:2
        
        fname = sprintf( 'tf_tc_SUBJ%03i_RUN%i_Reref_Avg_ALL.mat', subjs(s), r ) ;
        
        fprintf( '%s\n', fname );
        
        freq_subj_run{ind} = load( fullfile( data_dir, fname ) );
        
        elec =  freq_subj_run{ind}.freq.elec;
        
        ind = ind + 1;
    end
    
    data.x = [];
    data.y = [];
    data_mean_trial.x = [];
    data_mean_trial.y = [];
    data.x_desc = [];
    data_mean_trial.x_desc = [];
         
    [x1 desc x1_desc x1_mean_trial x1_mean_trial_desc] = extract_freq( freq_subj_run{1}.freq, freqs, data.toi, data.trialinfo, data.baseline);
    [x2 desc x2_desc x2_mean_trial x2_mean_trial_desc] = extract_freq( freq_subj_run{2}.freq, freqs, data.toi, data.trialinfo, data.baseline);
        
    inds1 = match_trials( x1_mean_trial_desc, ons.obj_cond_run1 );
    inds2 = match_trials( x2_mean_trial_desc, ons.obj_cond_run2 );
    
    if length(inds1) ~= length(x1_mean_trial_desc) || length(inds2) ~= length(x2_mean_trial_desc)
        error( 'error in matching trials' )
    end
    
    y1 = ons.rat_synch_run1(inds1);
    y2 = ons.rat_synch_run1(inds2);
    
    wins_per_trial1 = get_wins_per_trial( x1_mean_trial_desc, x1_desc );
    wins_per_trial2 = get_wins_per_trial( x2_mean_trial_desc, x2_desc );

    if length(wins_per_trial1) ~= length(y1) || length(wins_per_trial2) ~= length(y2)
        error( 'error in matching windows per trial' )
    end
        
    y = [];
    
    % repeat rating for all windows of the same trial 
    for w=1:length( wins_per_trial1 ) 
        y = [ y; repmat( y1(w), wins_per_trial1(w), 1 ) ];
    end
    % repeat rating for all windows of the same trial 
    for w=1:length( wins_per_trial2 ) 
        y = [ y; repmat( y2(w), wins_per_trial2(w), 1 ) ];
    end
    
    y_mean_trial = [y1 ; y2];

    data.x = [data.x; x1 ; x2];
    data.y = [data.y; y];

    data.x_desc = [data.x_desc; x1_desc; x2_desc];
    data_mean_trial.x_desc = [data_mean_trial.x_desc ; x1_mean_trial_desc ; x2_mean_trial_desc];

    data_mean_trial.x = [data_mean_trial.x ; x1_mean_trial ; x2_mean_trial];
    data_mean_trial.y = [data_mean_trial.y ; y_mean_trial ];

    data.features.desc = desc;
    data_mean_trial.features.desc = desc;
    
    fname = sprintf('SUBJ%03i.mat',subjs(s));
    
    str_baseline = '';
    if ~isempty( data.baseline ), str_baseline = 'baseline'; end;
    
    ddir = fullfile( data_classify, str_baseline );
    if ~isdir( ddir ), mkdir( ddir ), end
    save( fullfile( ddir, fname ) , 'data' );
    
    if ~isempty( str_baseline ), str_baseline = [str_baseline '_']; end;
    
    ddir = fullfile( data_classify, [str_baseline 'mean_trial'] );
    if ~isdir( ddir ), mkdir( ddir ), end
    data = data_mean_trial;
    save( fullfile( ddir, fname ) , 'data' );
        
end
