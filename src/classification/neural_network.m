function neural_network(config)

patts = {'sync' 'dens'};
subjs = config.subjs;

accs = [];
means = [];
outdir = fullfile(config.outdir_base, 'STATS/CLASSIFICATION/ANN');
accfilename = ['acc_featSelection_[sync_dens]_KFOLD_' datestr(now,'yymmdd.HHMMSS')];
for nS = subjs
    config.subjs = nS;
    subjid = sprintf('SUBJ%03d', nS);
    subjdir = fullfile(outdir, subjid);
    if ~isdir(subjdir), mkdir(subjdir); end
    featFile = fullfile(subjdir, 'feats.mat');
    
    % Check if need generate feat file
    if( ~exist(featFile, 'file') || utils.Var.get( config, 'force_features') )
        for nP = 1:length(patts)
            for nB = 1:length(config.bands)
                file  = sprintf('%sEEG_%d_%d', patts{nP}, config.bands(nB,:));
                
                group = group_matrix_eeg(config, file);
                srate = group.srate;
                channels = group.channels;
                
                % Feature selection - selecting channels
                [~, nchs] = intersect(channels, config.channels{nB, 2});
                nchs = sort(nchs);
                
                % Preparing data
                featEEG.TASK_T = group.data(:).TASK_T(nchs, :, :);
                featEEG.TASK_A = group.data(:).TASK_A(nchs, :, :);
                clear group;
                
                fileFeats = prepare_matrix( featEEG, srate );
                % Preparing matrix to use in classifier
                if ~exist('mFeats', 'var')
                    mFeats = fileFeats;
                else
                    mFeats = [mFeats fileFeats];
                end                
            end
        end
        save( featFile, 'mFeats' );
    else
        load(featFile, 'mFeats');
    end
    
    % Testing neural network
    net = patternnet(20);
    feats = prepare_features(mFeats);
    
    % Leave one block out
    acctxt = fullfile(subjdir, [accfilename '.txt']);
    %accs = [accs; loocv(feats, net, acctxt)];
    accs = [accs; kfold_cv(4, 100, feats, net, acctxt)];
    
    means(nS) = mean(accs(nS,:));
    utils.file.txt_write(acctxt, sprintf('SUBJ%03d [mean] \t %.2f%%\n', nS, means(nS)*100), 0, 1 );
    
    clear mFeats net y feats pEEG syncEEG;
end

save( fullfile(outdir, [accfilename '.mat']), 'accs');

end