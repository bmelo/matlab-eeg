function pdc_dtf_eeg( EEG, config )
%PDC_DTF_EEG Summary of this function goes here
%   Detailed explanation goes here

EEG = epochs_apply(@remove_outliers, EEG, 2, config.srate, config.srate*.5);
EEG = epochs_apply(@normalize_eeg, EEG);
feats = prepare_matrix( matrices(EEG), config.srate );

config.Fmax = 50; % Frequencia de corte, deve ser menor que Fs/2
config.Nf = 45;   % Numero de bins de frequencia para calcular a PDC

SUBJDIROUT = fullfile( config.outdir_base, 'FEATS', sprintf('%s%03d', config.subj_prefix, config.subj) );

PDC.N = computeCon( feats.N, config );
eeg_save( SUBJDIROUT, 'l_conn_feats_N', PDC );
clear PDC;

PDC.T = computeCon( feats.T, config );
eeg_save( SUBJDIROUT, 'l_conn_feats_T', PDC );
clear PDC;

PDC.A = computeCon( feats.A, config );
eeg_save( SUBJDIROUT, 'l_conn_feats_A', PDC );
clear PDC;
end


%% Computes PDC for y
function [PDC] = computeCon( y, config )
srate = config.srate;
% Setup for PDC
nchs = size(y,1);
pmax = 13;
nmerge = ceil( (pmax * 1000) / srate ); % Number of windows to merge to use choosen pmax

% Breaking data in small windows
y = matrix_window( y, srate, srate/2 );
nwins = size(y,2);
PDC = zeros(nchs, nchs, config.Nf, nwins);
DTF = PDC;

f = tic;
for nW = 1:nwins
    ymerge = permute( y(:, nW:(nW+nmerge-1), :), [1 3 2] );
    yW = reshape( ymerge, nchs, [] );
    [~, A, ~, sbc, ~, ~] = arfit(yW', 1, pmax, 'sbc'); % ---> ARFIT toolbox
    [~,p_opt] = min(sbc);
    PDC(:, :, :, nW) = PDC_matrix(A, p_opt, config.srate, config.Fmax, config.Nf);
    fprintf('%03d/%03d\n', nW, nwins);
    % Last windows have the same result
    if nW+nmerge > nwins
        for nnW = nW+1:nwins
            PDC(:, :, :, nnW) = PDC(:, :, :, nW);
        end
        break;
    end
end
toc(f)

% Ignoring bad channels
ignorechs = find([config.ignore{:,1}] == config.subj);
if ~isempty(ignorechs)
    ignchs = config.ignore{ignorechs, 2};
    PDC(ignchs, :, :, :) = NaN;
    PDC(:, ignchs, :, :) = NaN;
end

end


%% Function to break signal in windows, putting more one dimension
function new_signal = matrix_window( signal, window, overlap )
size_data = size(signal,2);

win_overlap = window - overlap;

% Filling all values
nWin = 1;
new_signal = zeros(size(signal,1), size_data/win_overlap, window);
for k = 1:win_overlap:size_data
    last = k+win_overlap-1;
    
    if last+overlap > length(signal) % Stops here
        break; 
    else
        intervM = k:last+overlap;
    end
    
    new_signal(:, nWin, :) = signal(:, intervM);
    nWin = nWin+1;
end

end