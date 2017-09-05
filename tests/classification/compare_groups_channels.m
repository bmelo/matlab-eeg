function run_classification()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;

%% Setup of processing
config = setup('neutral_length', 10);

config.subjs = [1 2 8 9];
config.features = {'l_power_rel_feats' 'l_erders_feats'};
config.bands = [8 13; 13 26; 26 45];
config.prefix = '';

config.featselection = 1;
setups = {
    {'F3' 'F4' 'C3 ,C4' 'P3' 'P4' 'F7' 'F8'} % meta-analysis
    {'AF3' 'AF4' 'F3' 'F4' 'F7' 'F8' 'FC5' 'FC6' 'P7' 'P8'} % emotiv
    {'FC5' 'FC6' 'FC3' 'FC4' 'C5' 'C6' 'C3' 'C4' 'CP5' 'CP6' 'CP3' 'CP4' 'P7' 'P8' 'P5' 'P6' 'P3' 'P4' 'PO7' 'PO6' 'PO3' 'PO4'} % Murugappan 2010
    {'CP3' 'CP4' 'P7' 'P8' 'P5' 'P6' 'PO7' 'PO4'} % Murugappan 2010
    {'Fp1' 'Fp2' 'F7' 'F3' 'Fz' 'F4' 'F8' 'FT7' 'FC3' 'FCz' 'FC4' 'FT8' 'T7' 'C3' 'Cz' 'C4' 'T8' 'TP7' 'CP3' 'CPz' 'CP4' 'TP8' 'P7' 'P3' 'Pz' 'P4' 'P8' 'O1' 'Oz' 'O2'} % Lin 2010
};

for setup_atual = 0:5
    config.featselection = setup_atual;
    if setup_atual > 0
        config.channels = {
            [8 13],  setups{setup_atual}
            [13 26], setups{setup_atual}
            [26 45], setups{setup_atual}
            };
    end
    config.outdir = ['STATS/CLASSIFICATION/ANN/FEATS-LAPLACE-ALPHA+BETA_opt' num2str(setup_atual)];
    
    accs = neural_network(config);
    fprintf('TOTAL: %.2f%%\n', mean( median(accs, 2) ) * 100);
    %neural_network_intersubjs(config);
end