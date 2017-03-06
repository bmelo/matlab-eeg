function signal = filter_bands( signal, bands )
%FILTER_BANDS Remove bands using butter filter
%   Detailed explanation goes here
%

freq = 500;

%Filter to be used
[b,a] = butter(4, bands/(freq/2));

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

end

