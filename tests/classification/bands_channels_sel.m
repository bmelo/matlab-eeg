function [ out_channels ] = bands_channels_sel( config, channels )
%FILTER_BANDS Summary of this function goes here
%   Detailed explanation goes here
nBands = length(config.bands);
out_channels = cell(nBands, 2);

for nB = 1:length(config.bands)
    out_channels{nB,1} = config.bands(nB, :);
    out_channels{nB,2} = channels;
end

end

