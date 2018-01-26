function gpdc_eeg( EEG, config )
%PDC_DTF_EEG Summary of this function goes here
%   Detailed explanation goes here

EEG = epochs_apply(@remove_outliers, EEG, 2, config.srate, config.srate*.5);

% Merging channels
if config.proc.group_channels
    good_chs = filter_bad_channels({EEG.chanlocs.labels}, config);
    EEG = epochs_apply_all_chs(@group_channels, EEG, good_chs, config.proc.groups);
    config.channels = config.proc.groups(:,1);

    EEG = epochs_apply(@normalize_eeg, EEG);
    [feats, idx_chs_removed] = prepare_matrix( matrices(EEG), config.srate, 1 );

    % Saving remaining and removed channels labels
    config.channels_removed = config.channels(idx_chs_removed);
    config.channels = config.channels(~idx_chs_removed);
else
    EEG = epochs_apply(@normalize_eeg, EEG);
    feats = prepare_matrix( matrices(EEG), config.srate, 1 );
end

config.Fmax = 50; % Frequencia de corte, deve ser menor que Fs/2
config.Nf = 50;   % Numero de bins de frequencia para calcular a PDC

SUBJDIROUT = fullfile( config.outdir_base, 'FEATS', sprintf('%s%03d', config.subj_prefix, config.subj) );

GPDC.N = computeConn( feats.N, config );
GPDC.T = computeConn( feats.T, config );
GPDC.A = computeConn( feats.A, config );
GPDC.config = config;

eeg_save( SUBJDIROUT, 'l_conn_gpdc', GPDC );
clear GPDC;
end


%% Computes PDC for y
function [GPDC] = computeConn( y, config )
srate = config.srate;
% Setup for PDC
nchs = size(y,1);
pmax = 20;
npoints = srate;
nmerge = ceil( npoints / srate ); % Number of windows to merge to use choosen pmax

% Breaking data in small windows
yMatrix = matrix_window( y, srate, srate/2 );
nwins = size(yMatrix, 2);
GPDC = zeros(nchs, nchs, config.Nf, nwins);

f = tic;
for nW = 1:nwins
    ymerge = permute( yMatrix(:, nW:(nW+nmerge-1), :), [1 3 2] );
    yW = reshape( ymerge, nchs, [] );
    
    [ARF,~,~,DC] = mvar(yW', pmax, 7);
    
    % estimate connectivity for this window
    ConnTmp = est_mvtransfer('AR', ARF, ...
                             'C',  DC,  ...
                             'freqs', 1:config.Fmax,  ...
                             'srate',srate,...
                             'connmethods', 'GPDC', ...
                             'arg_direct', true);
    
    GPDC(:, :, :, nW) = ConnTmp.GPDC;
    fprintf('%03d/%03d\n', nW, nwins);
    
    % Merged windows that exceed signal size must be removed!
    if nW+nmerge > nwins
        GPDC(:, :, :, nW+1:nwins) = [];
        break;
    end
end
toc(f)

end


%% Function to break signal in windows, putting more one dimension
function new_signal = matrix_window( signal, window, overlap )
size_data = size(signal,2);

win_overlap = window - overlap;

% Filling all values
nWin = 0;
totalWin = (size_data/win_overlap) - (ceil(window/overlap) - 1);
new_signal = zeros(size(signal,1), totalWin, window);
for k = 1:win_overlap:size_data
    last = k+window-1;
    
    if last > length(signal) % Stops here
        break; 
    else
        intervM = k:last;
        nWin = nWin+1;
    end
    
    new_signal(:, nWin, :) = signal(:, intervM);
end

end