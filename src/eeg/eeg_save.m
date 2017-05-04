function eeg_save( subjdir, filename, EEG )
%SAVE_EEG Summary of this function goes here
%   Detailed explanation goes here

fullfilename = fullfile( subjdir, filename );

s = tic;
fprintf('Saving file %s.mat\n', fullfilename);
save(fullfilename, 'EEG', '-v7.3');
print_done(s);

end

