function EEG = eeg_load( subjdir, filename, varargin )
%EEG_LOAD Summary of this function goes here
%   Detailed explanation goes here

fullfilename = fullfile( subjdir, filename );

s = tic;
fprintf('Loading file %s.mat\n', fullfilename);
load(fullfilename, 'EEG');
print_done(s);
for k = 1:length(varargin)
    EEG(k+1) = eeg_load(subjdir, varargin{k});
end

end

