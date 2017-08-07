function neural_network(config)
import utils.strjoin;

patts = config.patts;
subjs = config.subjs;

accs = [];
outdir = fullfile(config.outdir_base, config.outdir);
strdate = datestr(now,'yymmdd.HHMMSS');
strpatts = strjoin(patts, '_');
feats = strjoin(config.features, '_');
accfilename = sprintf('acc_%s[%s]_[%s]_%s_%s', config.prefix, strpatts, feats, config.cross.type, strdate);
for nS = subjs
    config.subjs = nS;
    subjid = sprintf('SUBJ%03d', nS);
    subjdir = fullfile(outdir, subjid);
    if ~isdir(subjdir), mkdir(subjdir); end
    
    % Check if need generate feat file
    for nP = 1:length(patts)
        % Each band
        for nB = 1:size(config.bands, 1)
            file  = gen_filename(patts{nP}, config.bands(nB,:)); % Generates filename
            
            group = group_matrix_features(config, file);
            srate = group.srate;
            channels = group.channels;
            
            % Each feature
            for nFeat = 1:length(config.features)
                feat = config.features{nFeat};
                
                % When feature doesnt exist in a setup
                if ~isfield( group,  feat)
                    warning( 'Feature %s not found! Ignoring.', feat );
                    continue
                end
                
                % Feature selection - selecting channels
                if config.featselection
                    [~, nchs] = intersect(channels, config.channels{nB, 2});
                    nchs = sort(nchs);
                else
                    nchs = 1:length(channels);
                end
                
                % Preparing data
                featEEG.TASK_T = group.(feat).data(:).TASK_T(nchs, :, :);
                featEEG.TASK_A = group.(feat).data(:).TASK_A(nchs, :, :);
                
                fileFeats = prepare_matrix( featEEG, srate );
                % Preparing matrix to use in classifier
                if ~exist('mFeats', 'var')
                    mFeats = fileFeats;
                else
                    mFeats = [mFeats fileFeats];
                end
            end
        end
    end
    
    % Testing neural network
    nHidden = max( [10 length(config.bands)*length(patts)] ); % 10 or num of features
    net = patternnet(nHidden);
    net.divideParam.trainRatio = .8;
    net.divideParam.valRatio   = .2;
    net.divideParam.testRatio  = 0;
    net.trainParam.max_fail    = 10;
    
    random_classes = utils.Var.get(config, 'random_classes');
    feats = prepare_features(mFeats, random_classes);        
    
    acctxt = fullfile(subjdir, [accfilename '.txt']);
    
    % KFOLD
    if strcmp( config.cross.type, 'montecarlo' )
        accs_subj = montecarlo(config.cross.k, config.cross.repetitions, feats, net, acctxt);
    else
        % Leave one block out
        accs_subj = kfold(config.cross.k, config.cross.repetitions, feats, net, acctxt);
    end
    accs = [accs; accs_subj];
    
    utils.file.txt_write(acctxt, sprintf('SUBJ%03d [mean] \t %.2f%%', nS, mean(accs_subj)*100), 0, 1 );
    utils.file.txt_write(acctxt, sprintf('SUBJ%03d [median] \t %.2f%%', nS, median(accs_subj)*100), 0, 1 );
    
    clear mFeats net feats;
end

save( fullfile(outdir, [accfilename '.mat']), 'accs', 'config');

end