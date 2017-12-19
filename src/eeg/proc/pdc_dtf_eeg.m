function [ PDC, DTF ] = pdc_dtf_eeg( EEG, srate )
%PDC_DTF_EEG Summary of this function goes here
%   Detailed explanation goes here

nEEG  = epochs_apply(@normalize_eeg, EEG);
feats = prepare_matrix( matrices(nEEG), srate );

Fmax = 50; % Frequencia de corte, deve ser menor que Fs/2
Nf = 40; % Numero de bins de frequencia para calcular a PDC
y = feats.N;
[~, A, ~, sbc, ~, ~] = arfit(y', 1, 20, 'sbc'); % ---> ARFIT toolbox
[~,p_opt] = min(sbc);
%[auxPDC, auxDTF] = PDC_DTF_matrix(A,p_opt,fs,100,100);
[PDC, DTF] = PDC_DTF_matrix(A, p_opt, srate, Fmax, Nf);

end

