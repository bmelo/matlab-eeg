function accs = neural_network(config, save_out)
import utils.strjoin;

if nargin < 2, save_out = true; end

patts = config.features;
subjs = config.subjs;

accs = [];
outdir = fullfile(config.outdir_base, config.outdir);
strdate = datestr(now,'yymmdd.HHMMSS');
strpatts = strjoin(patts, '_');
feats = strjoin(config.measures, '_');
accfilename = sprintf('acc_%s[%s]_[%s]_%s_%s', config.prefix, strpatts, feats, config.cross.type, strdate);
for nS = subjs
    config.subjs = nS;
    subjid = sprintf('SUBJ%03d', nS);
    subjdir = fullfile(outdir, subjid);
    if ~isdir(subjdir) && save_out, mkdir(subjdir); end
    
    % Check if need generate feat file
    for nP = 1:length(patts)
        % Each band
        for nB = 1:size(config.bands, 1)
            file  = gen_filename(patts{nP}, config.bands(nB,:)); % Generates filename
            
            group = group_matrix_features(config, file);
            srate = group.srate;
            channels = group.channels;
            
            % Each measure
            for nFeat = 1:length(config.measures)
                feat = config.measures{nFeat};
                
                % When feature doesnt exist in a setup
                if ~isfield( group,  feat)
                    warning( 'Measure %s not found! Ignoring.', feat );
                    continue
                end
                
                % Feature selection - selecting channels
                if config.featselection
                    [~, nchs] = intersect(channels, config.channels{nB, 2});
                    nchs = sort(nchs);
                    % Checking if all channels were found
                    if length(config.channels{nB, 2}) ~= length(nchs)
                        selchs = sort(config.channels{nB, 2});
                        foundchs = sort(channels(nchs));
                        
                        warning('ann:featselec:notfound', 'Some channels not found! [%s] vs [%s]', ...
                        sprintf('%s ', foundchs{:}), ...
                        sprintf('%s ', selchs{:}) ...
                        );
                    end
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
    net.trainParam.max_fail    = utils.Var.get( config, 'max_fail', 10);
    net.trainParam.showWindow  = utils.Var.get( config, 'show_window', 1 );
    
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
    
    if save_out
        utils.file.txt_write(acctxt, sprintf('SUBJ%03d [mean] \t %.2f%%', nS, mean(accs_subj)*100), 0, 1 );
        utils.file.txt_write(acctxt, sprintf('SUBJ%03d [median] \t %.2f%%', nS, median(accs_subj)*100), 0, 1 );
    end
    
    clear mFeats net feats;
end

if save_out
    save( fullfile(outdir, [accfilename '.mat']), 'accs', 'config');
end

end