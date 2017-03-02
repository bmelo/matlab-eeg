function plot_eeg( EEG, AUX )
%PLOT_EEG Summary of this function goes here
%   Detailed explanation goes here

% Channels to check: (Fp1, Fp2, F5, F6) - 1,2,46,47
pop_eegplot( EEG, 1, 1, 1);
eegplot( EEG, 'title', 'CANAIS EEG' );
eegplot( AUX, 'title', 'AUXILIARES' );

end

