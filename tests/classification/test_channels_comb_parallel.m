% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)
curdir = pwd;
addpath(curdir);

% Preparing components (eeglab, matlab-utils)
cd ../..;
init_app;
clc;

%matlabpool open local 12
%parfor k=2:63
for k=63
    accs = chs_acc('tests/classification/CHANNELS');
    [vals, idxs] = sort(accs, 'descend');
    testa_canais( idxs(1:k) );
end
%matlabpool close

cd(curdir);