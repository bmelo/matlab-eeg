function [ varargout ] = filter_bad_channels( channels, config )
%FILTER_BAD_CHANNELS Used to remove bad channels from a list of all channels
% Returns filtered channels list and bad channels indexes
idx = find([config.ignore{:,1}] == config.subj);
idx_chs = config.ignore{idx, 2};
 
% Removing bad channels of grouping
if ~isempty(idx) && ~isempty(channels)
    channels(idx_chs) = [];
end

if nargout == 1
    varargout = {channels};
elseif nargout == 2
    varargout = {channels, idx_chs};
end
end

