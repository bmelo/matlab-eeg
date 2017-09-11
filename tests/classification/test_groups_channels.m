% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;

%% Setup of processing
config = setup('neutral_length', 10);

config.subjs = [1 2 8 9];
config.features = {'l_power_rel_feats' 'l_erders_feats'};
config.bands = [8 13; 13 30; 30 45];
config.prefix = '';

config.featselection = 1;
borda = {'P7' 'P8' 'P5' 'P6' 'CP5' 'CP6' 'C5' 'C6' 'FC5' 'FC6' 'F5' 'F6' 'F7' 'F8'};
setups = {
    {'Fp1' 'Fp2' 'F3' 'F4' 'C3' 'C4' 'P3' 'P4' 'O1' 'O2' 'F7' 'F8' 'T7' 'T8' 'P7' 'P8' 'Fz' 'Cz' 'Pz' 'Oz' 'FC1' 'FC2' 'CP1' 'CP2' 'FC5' 'FC6' 'CP5' 'CP6' 'TP9' 'TP10' 'POz' 'F1' 'F2' 'C1' 'C2' 'P1' 'P2' 'AF3' 'AF4' 'FC3' 'FC4' 'CP3' 'CP4' 'PO3' 'PO4' 'F5' 'F6' 'C5' 'C6' 'P5' 'P6' 'AF7' 'AF8' 'FT7' 'FT8' 'TP7' 'TP8' 'PO7' 'PO8' 'FT9' 'FT10' 'Fpz' 'CPz'} % All
    {'Fp1' 'Fp2' 'F3' 'F4' 'C3' 'C4' 'P3' 'P4' 'O1' 'O2' 'F7' 'F8' 'P7' 'P8' 'Fz' 'Cz' 'Pz' 'Oz' 'FC1' 'FC2' 'CP1' 'CP2' 'FC5' 'FC6' 'CP5' 'CP6' 'POz' 'F1' 'F2' 'C1' 'C2' 'P1' 'P2' 'AF3' 'AF4' 'FC3' 'FC4' 'CP3' 'CP4' 'PO3' 'PO4' 'F5' 'F6' 'C5' 'C6' 'P5' 'P6' 'AF7' 'AF8' 'PO7' 'PO8' 'Fpz' 'CPz'} % All - temporal
    {'Fp1' 'Fp2' 'F3' 'F4' 'C3' 'C4' 'P3' 'P4' 'F7' 'F8' 'P7' 'P8' 'Fz' 'Cz' 'Pz' 'FC1' 'FC2' 'CP1' 'CP2' 'FC5' 'FC6' 'CP5' 'CP6' 'F1' 'F2' 'C1' 'C2' 'P1' 'P2' 'AF3' 'AF4' 'FC3' 'FC4' 'CP3' 'CP4' 'F5' 'F6' 'C5' 'C6' 'P5' 'P6' 'AF7' 'AF8' 'Fpz' 'CPz'} % All - temporal e occipital
    {'F3' 'F4' 'C3' 'C4' 'P3' 'P4' 'F7' 'F8'} % meta-analysis
    {'AF3' 'AF4' 'F3' 'F4' 'F7' 'F8' 'FC5' 'FC6' 'P7' 'P8'} % emotiv
    {'FC5' 'FC6' 'FC3' 'FC4' 'C5' 'C6' 'C3' 'C4' 'CP5' 'CP6' 'CP3' 'CP4' 'P7' 'P8' 'P5' 'P6' 'P3' 'P4' 'PO7' 'PO8' 'PO3' 'PO4'} % Murugappan 2010
    {'CP3' 'CP4' 'P7' 'P8' 'P5' 'P6' 'PO7' 'PO8'} % Murugappan 2010
    {'Fp1' 'Fp2' 'F7' 'F8' 'F3' 'F4' 'FT7' 'FT8' 'FC3' 'FC4' 'C3' 'C4' 'TP7' 'TP8' 'CP3' 'CP4' 'P3' 'P4' 'P7' 'P8' 'O1' 'O2' 'Fz' 'Cz' 'CPz' 'Pz' 'Oz'} % Lin 2010 removed T7, T8 and FCz]
    {'T7' 'T8' 'TP9' 'TP10' 'FT7' 'FT8' 'TP7' 'TP8' 'FT9' 'FT10'} % Temporal
    {'O1' 'O2' 'Oz' 'POz' 'PO3' 'PO4' 'PO7' 'PO8'} % Occipital
    {'T7' 'T8' 'TP9' 'TP10' 'FT7' 'FT8' 'TP7' 'TP8' 'FT9' 'FT10' 'O1' 'O2' 'Oz' 'POz' 'PO3' 'PO4' 'PO7' 'PO8'} % Temporal + Occipital
    };

totais = zeros(1, length(setups));
for nS = 9:11
    config.channels = {
        [8 13],  setups{nS}
        [13 30], setups{nS}
        [30 45], setups{nS}
        };
    
    config.outdir = ['STATS/CLASSIFICATION/ANN/FEATS-LAPLACE-ALPHA+BETA+GAMMA_opt' num2str(nS)];
    
    accs = neural_network(config);
    totais(nS) = mean( median(accs, 2) );
    fprintf('TOTAL: %.2f%%\n', totais(nS)*100 );
    %neural_network_intersubjs(config);
end

disp('#################');
disp('TOTAIS:')
fprintf('%d%%\n', round(totais*100) );

