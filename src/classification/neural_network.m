function neural_network(config)

files = {'pEEG_global' 'pEEG_8_13' 'pEEG_13_26' 'pEEG_26_45'};

for k = 1:length(files)
    file  = files{k};
    
    group = group_matrix_eeg(config, file);
    srate = group.srate;
    channels = group.channels;
    
    pEEG.TASK_T = [group.data(:).TASK_T];
    pEEG.TASK_A = [group.data(:).TASK_A];
    clear group;
    
    syncEEG = epochs_apply_matrices(@erd_ers, pEEG, srate, srate/5, [srate*5 srate*10] );
    perc = size(syncEEG.TASK_T,3) / size(pEEG.TASK_T,3);
    pEEG = epochs_apply_matrices( @window_func, pEEG, srate, srate/5, @mean );
    
    srate = srate * perc;
    
    % Preparing matrix to use in classifier
    mFeats = prepare_matrix( pEEG, srate );
    mFeats = [mFeats prepare_matrix( syncEEG, srate )];
    features = prepare_features(mFeats);
    
    % Testing neural network
    net = patternnet(10);
    net = train(net, features.data, features.classes);
    view(net);
end

%y = net( features.data );
%perf = perform(net, features.classes, y);
%classes = vec2ind( y );

end
