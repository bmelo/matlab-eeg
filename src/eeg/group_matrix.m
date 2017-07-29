function [ out ] = group_matrix( config, filename )
%GROUP_MATRIX Summary of this function goes here
%   Detailed explanation goes here

totalN = length(config.subjs);
srate = [];

% Extracting values
for k = 1:totalN
    subjN = config.subjs(k);
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    subjdir = fullfile( config.outdir_base, subj );
    
    EEG = eeg_load( subjdir, filename );
    % Validation
    if k == 1
        srate = EEG.srate;
        channels = {EEG.chanlocs(:).labels};
    elseif srate ~= EEG.srate
        error('Sample rate not matching!');
    end
    
    EEG = epochs_shrink( EEG, 46*srate );
    
    % Removing bad channels
    p_ignore = find( [config.ignore{:,1}] == k );
    if p_ignore
        EEG = ignore_bad_channels( EEG, config.ignore{ p_ignore, 2 } );
    end
    
    epochs = matrices(EEG);
    %data(k) = epochs;
    pw_mean(k).TASK_T(:,:) = squeeze(mean(epochs.TASK_T,2));
    pw_mean(k).TASK_A(:,:) = squeeze(mean(epochs.TASK_A,2));
    
    sync_mean(k) = epochs_apply_matrices(@erd_ers, pw_mean(k), [srate*5 srate*10] );
    
    clear EEG;
end

pw_mean = str2mat( pw_mean );
sync_mean = str2mat( sync_mean );

sync_grand = calculate_means();
perc = size(sync_grand.TASK_T,2)/size(pw_mean.TASK_T,3);

out.matrix = sync_mean;
out.mean = sync_grand;
out.srate = srate * perc;
out.channels = channels;

%%%%%%%%%%%%%%%%%%%%%%
    function matvals = str2mat( strvals )
        conds = fields(strvals);
        for cond=conds'
            cond = cond{1};
            sizeV = size(strvals(1).(cond));
            matvals.(cond) = reshape( [strvals(:).(cond)], sizeV(1), sizeV(2), []);
            matvals.(cond) = permute(matvals.(cond), [3 1 2]);
        end
    end

%%%%%%%%%%%%%%%%%%%%
    function sync_grand = calculate_means()
        nchs = size(sync_mean.TASK_T, 2);
        for nCh = 1:nchs
            idxS = ~isnan(sync_mean.TASK_T(:,nCh,1));
            % Working only with remaining channels
            if( any(idxS) )
                pw_grand.TASK_T(nCh,:) = squeeze( mean(pw_mean.TASK_T(idxS,nCh,:), 1)  );
                pw_grand.TASK_A(nCh,:) = squeeze( mean(pw_mean.TASK_A(idxS,nCh,:), 1)  );
            end
        end
        % Generating ERD/ERS
        sync_grand = epochs_apply_matrices( @erd_ers, pw_grand, srate, srate/5, [srate*5 srate*10] );
    end

end

