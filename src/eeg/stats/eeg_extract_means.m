function [ out ] = eeg_extract_means( epoch, interval )
%EEG_EXTRACT_MEANS Summary of this function goes here
%   Detailed explanation goes here

idx = interval(1)+1:interval(2);
out = mean( epoch.data( :, idx), 2 );

end

