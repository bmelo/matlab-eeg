% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
[~, rootdir] = fileattrib('../../..');
addpath( rootdir.Name );
init_app;
clc;

pool = parpool('local', 30);
parfor k=1:63
    testa_canais(k);
end
delete(pool)