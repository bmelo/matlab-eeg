function eeg_save( filename, EEG )
%SAVE_EEG Summary of this function goes here
%   Detailed explanation goes here

save(filename, 'EEG', '-v7.3');

end

