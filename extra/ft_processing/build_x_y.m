
% loop over subjects
for s=1:length(subjs)
    
    freq_subj_run = [];
    ind = 1;
    
    % loop over runs
    for r=1:2
        
        fname = sprintf( 'tf_tc_SUBJ%03i_RUN%i_Reref_Oz_ALL.mat', subjs(s), r ) ;
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
    inds_run1 = [];
    inds_run2 = [];
    inds_run1_mean_trial = [];
    inds_run2_mean_trial = [];
    for c=1:length(data.class)
        
        [x1 desc x1_desc x1_mean_trial x1_mean_trial_desc] = extract_freq( freq_subj_run{1}.freq, freqs, data.class(c).toi, data.class(c).trialinfo, data.baseline);
        [x2 desc x2_desc x2_mean_trial x2_mean_trial_desc] = extract_freq( freq_subj_run{2}.freq, freqs, data.class(c).toi, data.class(c).trialinfo, data.baseline);
                
        y = c * ones(size(x1,1)+size(x2,1),1);
        y_mean_trial = c * ones(size(x1_mean_trial,1)+size(x2_mean_trial,1),1);
        
        inds_run1 = [inds_run1 , size(data.x,1) + [1:size(x1,1)] ];
        inds_run2 = [inds_run2 , size(data.x,1) + size(x1,1) + [1:size(x2,1)] ];

        inds_run1_mean_trial = [inds_run1_mean_trial , size(data_mean_trial.x,1) + [1:size(x1_mean_trial,1)] ];
        inds_run2_mean_trial = [inds_run2_mean_trial , size(data_mean_trial.x,1) + size(x1_mean_trial,1) + [1:size(x2_mean_trial,1)] ];

        data.x = [data.x; x1 ; x2];
        data.y = [data.y; y];
        
        data.x_desc = [data.x_desc; x1_desc; x2_desc];
        data_mean_trial.x_desc = [data_mean_trial.x_desc ; x1_mean_trial_desc ; x2_mean_trial_desc];
            
        data_mean_trial.x = [data_mean_trial.x ; x1_mean_trial ; x2_mean_trial];
        data_mean_trial.y = [data_mean_trial.y ; y_mean_trial ];

        
    end
    
    if transform_Z_per_run
        data.x(inds_run1,:) = zscore(data.x(inds_run1,:));
        data.x(inds_run2,:) = zscore(data.x(inds_run2,:));
        
        data_mean_trial.x(inds_run1_mean_trial,:) = zscore(data_mean_trial.x(inds_run1_mean_trial,:));
        data_mean_trial.x(inds_run2_mean_trial,:) = zscore(data_mean_trial.x(inds_run2_mean_trial,:));
    end
    
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
