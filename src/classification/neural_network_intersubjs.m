function neural_network_intersubjs(config)

subjs = config.subjs;

load('mFeatsGlobal');
%save( fullfile( config.imgsexport_dir, 'all_feats' ), 'mFeatsGlobal');

%% GLOBAL
feats = prepare_features_group(mFeatsGlobal, length(config.subjs) );


% Leave one subject out
for nS = subjs
    net = patternnet(20);
    s_idx = feats.nsubj == nS;
    net = train(net, feats.features( :, ~s_idx), feats.classes(:, ~s_idx));
    out_test = net( feats.features(:, s_idx));
    er = confusion( feats.classes(:, s_idx), out_test);
    acc = 1-er;
    fprintf('SUBJ%03d \t %.2f%% \t %d \t %d \t %d \t %d\n', nS, acc*100, sum(s_idx), find(s_idx, 1), sum(~s_idx), find(~s_idx,1) );
    %plotconfusion(feats.classes(:, s_idx), out);
    accs(nS) = acc;
    
    clear net;
end
fprintf('\nMEAN: \t %.2f%%\n', mean(accs)*100);


end
