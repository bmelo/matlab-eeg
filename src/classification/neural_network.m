function neural_network(config)

files = {'pEEG_global' 'pEEG_8_13' 'pEEG_13_26' 'pEEG_26_45'};
subjs = config.subjs;

for nS = subjs
    config.subjs = nS;
    
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
        if ~exist('mFeats', 'var')
            mFeats = prepare_matrix( pEEG, srate );
        else
            mFeats = [mFeats prepare_matrix( pEEG, srate )];
        end
        mFeats = [mFeats prepare_matrix( syncEEG, srate )];
    end
    
    % For global Analysis
    if ~exist('mFeatsGlobal', 'var')
        mFeatsGlobal = mFeats;
    else
        mFeatsGlobal = [mFeatsGlobal mFeats];
    end
    
    % Testing neural network
    feats = prepare_features(mFeats);
    
    net = patternnet(10);
    net = train(net, feats.features, feats.classes);
    %view(net);
    y = net(feats.features);
    plotconfusion( feats.classes, y );
    utils.imgs.print_fig( fullfile( config.imgsexport_dir, sprintf('SUBJ%03d.png', nS) ) );
    
    clear mFeats net y feats pEEG syncEEG;
end


%% GLOBAL
% Testing neural network
feats = prepare_features(mFeatsGlobal);

net = patternnet(10);
net = train(net, feats.features, feats.classes);
%view(net);
y = net(feats.features);
plotconfusion( feats.classes, y );
utils.imgs.print_fig( fullfile( config.imgsexport_dir, sprintf('GLOBAL.png', nS) ) );

%y = net( features.data );
%perf = perform(net, features.classes, y);
%classes = vec2ind( y );

end
