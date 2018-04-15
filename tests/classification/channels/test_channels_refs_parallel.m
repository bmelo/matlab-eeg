% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
addpath( fileparts( fileparts( pwd ) ) );
init_app;
clc;

refs = {
    {'F3' 'F4' 'C3' 'C4' 'P3' 'P4' 'F7' 'F8'} % meta-analysis
    {'AF3' 'AF4' 'F3' 'F4' 'F7' 'F8' 'T7' 'T8' 'P3' 'P4' 'P7' 'P8', 'FC5', 'FC6'} % emotiv
    {'FC5' 'FC6' 'FC3' 'FC4' 'C5' 'C6' 'C3' 'C4' 'CP5' 'CP6' 'CP3' 'CP4' 'P7' 'P8' 'P5' 'P6' 'P3' 'P4' 'PO7' 'PO8' 'PO3' 'PO4' 'O1' 'O2'} % Murugappan 2010
    {'CP3' 'CP4' 'P7' 'P8' 'P5' 'P6' 'PO7' 'PO8'} % Murugappan 2010
    {'Fp1' 'Fp2' 'F7' 'F8' 'F3' 'F4' 'FT7' 'FT8' 'FC3' 'FC4' 'C3' 'C4' 'TP7' 'TP8' 'CP3' 'CP4' 'P3' 'P4' 'P7' 'P8' 'O1' 'O2' 'Fz' 'Cz' 'CPz' 'Pz' 'Oz' 'T7' 'T8'} % Lin 2010 - 'FCz' removed
};

%pool = parpool('local', 30);
for k=2 %1:length(refs)
    label = sprintf('%02d', k);
    testa_canais( refs{k}, 'CHANNELS_REFS', label );
end
delete(pool);