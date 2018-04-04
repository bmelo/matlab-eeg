% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)
curdir = pwd;
addpath(curdir);

% Preparing components (eeglab, matlab-utils)
cd ../..;
init_app;
clc;

matlabpool open local 8
parfor k=1:63
    testa_canais(k);
end
matlabpool close

cd(curdir);