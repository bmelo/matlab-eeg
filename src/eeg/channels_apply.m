function [ EEG ] = channels_apply( hFunc, varargin )
%CHANNELS_APPLY Apply function to each channel
%   Detailed explanation goes here
tic;
fprintf('Applying function <a href="matlab:help %1$s">%1$s</a>\n', func2str(hFunc));

EEG = varargin{1};
% Each channel
for nCh = 1:size(EEG.data, 1)
    % Task
    varargin{1} = EEG.data(nCh,:);
    new_data(nCh,:) = utils.apply_func( hFunc, varargin );
end
% adjusting resize
perc = size(new_data,2) / size(EEG.data,2);
EEG.data = new_data;

% putting return value
EEG.srate = EEG.srate * perc;

secs = toc;
fprintf('Finished after %.2f s\n\n', secs);
end