function accs = neural_network(config, save_out)
import utils.strjoin;

if nargin < 2, save_out = true; end

feats_patts = config.features( ~cellfun(@isempty, strfind(config.features,'_feats') ));
conn_patts  = config.features( ~cellfun(@isempty, strfind(config.features,'_conn') ));
subjs = config.subjs;

accs = [];
outdir = fullfile(config.outdir_base, config.outdir);
strdate = datestr(now,'yymmdd.HHMMSS');
strpatts = strjoin(config.features, '_');
feats = strjoin(config.measures, '_');
accfilename = sprintf('acc_%s[%s]_[%s]_%s_%s', config.prefix, strpatts, feats, config.cross.type, strdate);
default_hidden = max( [10 length(config.bands)*length(config.features)] );


for nS = subjs
    config.subjs = nS;    
    config.subjid = sprintf('SUBJ%03d', config.subjs);
    config.subjdir = fullfile(config.outdir_base, 'FEATS', config.subjid);
    if ~isdir(config.subjdir) && save_out, mkdir(config.subjdir); end
    
    % Separating data according to type
    all_feats = get_feats(feats_patts, config);
    conn_feats = get_conn_feats(conn_patts, config);
    
    random_classes = utils.Var.get(config.ann, 'random_classes');
    feats = prepare_features([all_feats conn_feats], random_classes);
    
    % Filtering
    if utils.Var.get(config, 'filter_blocks')
        feats = filter_trials( feats, config.filter_blocks );
    end
    
    % Testing neural network
    n_hidden = utils.Var.get( config.ann, 'hidden', default_hidden );
    net = patternnet(n_hidden);
    net.divideParam.trainRatio = .8;
    net.divideParam.valRatio   = .2;
    net.divideParam.testRatio  = 0;
    net.trainParam.max_fail    = utils.Var.get( config.ann, 'max_fail', 10);
    net.trainParam.showWindow  = utils.Var.get( config.ann, 'show_window', 1 );
    
    acctxt = fullfile(config.subjdir, [accfilename '.txt']);
    
    % KFOLD
    if strcmp( config.cross.type, 'montecarlo' )
        accs_subj = montecarlo(config.cross.k, config.cross.repetitions, feats, net, acctxt);
    else
        % Leave one block out
        accs_subj = kfold(config.cross.k, config.cross.repetitions, feats, net, acctxt);
    end
    accs = [accs; accs_subj];
    
    if save_out
        smean   = mean(accs_subj)*100;
        smedian = median(accs_subj)*100;
        utils.file.txt_write(acctxt, sprintf('SUBJ%03d [mean] %.2f%%\t[median] %.2f%%\n', nS, smean, smedian), 0, 1 );
    end
    
    clear mFeats net feats;
end

if save_out
    save( fullfile(outdir, [accfilename '.mat']), 'accs', 'config');
end

end
% END


% Function to export features (not connectivity)
function mFeats = get_feats( patts, config )
mFeats = [];

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
            
            nchs = feature_selection(channels, nB, config);
            
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
end

% Function to export features (not connectivity)
function mData = get_conn_feats( patts, config )

conndir = fullfile(config.proc_dir, 'CONN', config.subjid);

% Check if need generate feat file
for nP = 1:length(patts)
    % Each band
    for nB = 1:size(config.bands, 1)
        file  = gen_filename(patts{nP}, config.bands(nB,:)); % Generates filename
        load( fullfile( conndir, file ));
        connData = EEG;
        
        dims = size( connData.A );
        connData.N = reshape(connData.N, [], dims(3));
        connData.T = reshape(connData.T, [], dims(3));
        connData.A = reshape(connData.A, [], dims(3));
        
        % Preparing matrix to use in classifier
        if ~exist('mData', 'var')
            mData = connData;
        else
            mData = [mData connData];
        end
    end
end
end

% Filtering data by trials (block)
function data = filter_trials( data, keep )

idx_keep = ismember(data.block, keep);
data.features(:,~idx_keep) = [];
data.classes(:,~idx_keep) = [];
data.block(:,~idx_keep) = [];

end

% Select only some channels
function nchs = feature_selection(channels, nB, config)

if config.ann.featselection
    [~, nchs] = intersect(channels, config.channels{nB, 2});
    nchs = sort(nchs);
    
    % Checking if all selected channels have been found
    if length(config.channels{nB, 2}) ~= length(nchs)
        notfound = setdiff(config.channels{nB, 2}, channels);
        notfoundlist = sprintf('%s ', notfound{:});
        warning('ann:featselec:notfound', 'Some channels were not found: %s', notfoundlist );
    end
else
    nchs = 1:length(channels);
end

end