% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
addpath( fileparts( fileparts( pwd ) ) );
init_app;
clc;
accs = chs_acc('CHANNELS');
[vals, idxs] = sort(accs);

pool = parpool('local', 30);
% ASCEND
parfor k=2:63
    testa_canais( idxs(1:k), 'CHANNELS_COMB_ASC' );
end

% DESCEND
[vals, idxs] = sort(accs, 'descend');
parfor k=2:63    
    testa_canais( idxs(1:k), 'CHANNELS_COMB' );
end

% RANDOM
idxs_random = randperm(63);
parfor k=1:63
    testa_canais( idxs_random(1:k), 'CHANNELS_COMB_RAND' );
end
delete(pool);