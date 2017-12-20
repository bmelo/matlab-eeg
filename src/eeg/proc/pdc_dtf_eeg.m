function [ PDC, DTF ] = pdc_dtf_eeg( EEG, srate )
%PDC_DTF_EEG Summary of this function goes here
%   Detailed explanation goes here

EEG = epochs_apply(@remove_outliers, EEG, 2, srate, srate*.5);
nEEG  = epochs_apply(@normalize_eeg, EEG);
feats = prepare_matrix( matrices(nEEG), srate );

Fmax = 50; % Frequencia de corte, deve ser menor que Fs/2
Nf = 40; % Numero de bins de frequencia para calcular a PDC
[PDC.N, DTF.N] = computeCon( feats.N );
[PDC.T, DTF.T] = computeCon( feats.T );
[PDC.A, DTF.A] = computeCon( feats.A );

% Computes PDC and DTF for y
function [PDC, DTF] = computeCon( y )
[~, A, ~, sbc, ~, ~] = arfit(y', 1, 20, 'sbc'); % ---> ARFIT toolbox
[~,p_opt] = min(sbc);
%[auxPDC, auxDTF] = PDC_DTF_matrix(A,p_opt,fs,100,100);
[PDC, DTF] = PDC_DTF_matrix(A, p_opt, srate, Fmax, Nf);
end

end