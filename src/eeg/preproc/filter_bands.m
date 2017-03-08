function EEG = filter_bands( EEG, bands )
%FILTER_BANDS Remove bands using butter filter
%   Detailed explanation goes here
%

signal = EEG.ext.epochs;
srate = EEG.srate;

%Filter to be used
[b,a] = butter(4, bands/(srate/2));

conds = fields(signal);
% Each condition
for nCond = 1:length(conds)
    cond = conds{nCond};
    % Each piece
    for p = 1:length(signal.(cond))
        % Each channel
        for nCh = 1:size(signal.(cond)(p).data, 1)
            signal.(cond)(p).data(nCh,:) = double(signal.(cond)(p).data(nCh,:));
            signal.(cond)(p).data(nCh,:) = filtfilt(b,a, double(signal.(cond)(p).data(nCh,:)));
        end
    end
end

% putting return value
EEG.ext.epochs = signal;

end

