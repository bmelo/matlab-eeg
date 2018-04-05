% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
addpath( fileparts( fileparts( pwd ) ) );
init_app;
clc;

%matlabpool open local 12
parfor k=1:63
    testa_canais(k);
end
matlabpool close