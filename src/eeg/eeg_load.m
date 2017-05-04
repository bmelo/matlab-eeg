function EEG = eeg_load( subjdir, filename )
%EEG_LOAD Summary of this function goes here
%   Detailed explanation goes here

fullfilename = fullfile( subjdir, filename );

s = tic;
fprintf('Loading file %s.mat\n', fullfilename);
load(fullfilename, 'EEG');
print_done(s);

end

