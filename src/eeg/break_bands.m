function multiEEG = break_bands( EEG, bands )
% BREAK_BANDS - split EEG in bands

for nB = 1:size(bands, 1)
    nEEG = epochs_apply( @filter_bands, EEG, EEG.srate, bands(nB, :) );
    nEEG.ext.bands = bands(nB, :);
    
    % Assigning new variable
    if ~exist('multiEEG','var')
        multiEEG = nEEG;
    else
        multiEEG(end+1) = nEEG;
    end
        
end