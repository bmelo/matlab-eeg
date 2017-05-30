function neural_network(config)

files = {'pEEG_global' 'pEEG_8_13' 'pEEG_13_26' 'pEEG_26_45'};
subjs = config.subjs;

accs = [];
means = [];
for nS = subjs
    config.subjs = nS;
    subjid = sprintf('SUBJ%03d', nS);
    featFile = fullfile(config.outdir_base, subjid, 'feats.mat');
    
    % Check if need generate feat file
    if( ~exist(featFile, 'file') )
        for k = 1:length(files)
            file  = files{k};
            
            group = group_matrix_eeg(config, file);
            srate = group.srate;
            %channels = group.channels;
            
            pEEG.TASK_T = [group.data(:).TASK_T];
            pEEG.TASK_A = [group.data(:).TASK_A];
            clear group;
            
            syncEEG = epochs_apply_matrices(@erd_ers, pEEG, srate, srate/5, [srate*5 srate*10] );
            perc = size(syncEEG.TASK_T,3) / size(pEEG.TASK_T,3);
            pEEG = epochs_apply_matrices( @window_func, pEEG, srate, srate/5, @mean );
            
            srate = srate * perc;
            
            % Preparing matrix to use in classifier
            if ~exist('mFeats', 'var')
                mFeats = prepare_matrix( pEEG, srate );
            else
                mFeats = [mFeats prepare_matrix( pEEG, srate )];
            end
            mFeats = [mFeats prepare_matrix( syncEEG, srate )];
        end
        save( featFile, 'mFeats' );
    else
        mFeats = load(featFile);
    end
    
    % Testing neural network
    feats = prepare_features(mFeats);
    
    % Leave one paired-block out
    acc = [];
    for nB = 1:16
        s_idx = feats.block == nB;
        
        net = patternnet(20);
        net = train(net, feats.features( :, ~s_idx), feats.classes(:, ~s_idx));
        out_test = net( feats.features(:, s_idx));
        er = confusion( feats.classes(:, s_idx), out_test);
        acc = 1-er;
        accs(nB) = acc;
        %utils.imgs.print_fig( fullfile( config.imgsexport_dir, sprintf('SUBJ%03d.png', nS) ) );
        fprintf('SUBJ%03d [%d] \t %.2f%% \t %d \t %d\n', nS, nB, acc*100, sum(s_idx), sum(~s_idx));
        clear net;
    end
    means(nS) = mean(accs);
    fprintf('SUBJ%03d [mean] \t %.2f%%\n', nS, means(nS)*100 );
    
    clear mFeats net y feats pEEG syncEEG;
end
feats = prepare_features_group(mFeatsGlobal, length(config.subjs) );

fprintf('\nMEAN: \t %.2f%%\n', mean(accs)*100);

end
