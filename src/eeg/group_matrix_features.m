function [ out ] = group_matrix_features( config, filename )
%GROUP_MATRIX_EEG Summary of this function goes here
%   Detailed explanation goes here

totalN = length(config.subjs);
srate = [];

% Extracting values
for k = 1:totalN
    subjN = config.subjs(k);
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    subjdir = fullfile( config.outdir_base, 'FEATS', subj );
    
    EEGfeats = eeg_load( subjdir, filename );
    
    if ~isfield( EEGfeats, 'data' )
        
        for nF = 1:length(config.measures)
            feat = config.measures{nF};
            EEG = EEGfeats.(feat);
            adjust_eeg();
            out.(feat).data(k) = matrices(EEG);
            
            clear EEG;
        end
        
    else
        EEG = EEGfeats;
        adjust_eeg();
        out.median.data(k) = matrices(EEG);
        clear EEG;
    end
end

out.srate = srate;
out.channels = channels;

%% Auxiliar function to manipule EEG
function adjust_eeg()

% Validation
if k == 1
    srate = EEG.srate;
    channels = {EEG.chanlocs(:).labels};
elseif srate ~= EEG.srate
    error('Sample rate not matching!');
end

EEG = epochs_shrink( EEG, 46*srate );

% Removing bad channels
p_ignore = find( [config.ignore{:,1}] == subjN );
if p_ignore
    EEG = ignore_bad_channels( EEG, config.ignore{ p_ignore, 2 } );
end

end % adjust_eeg

end % main end