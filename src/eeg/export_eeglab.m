function export_eeglab( params, filename )
% EXPORT_EEGLAB (params, filename)

load('extra/example_eeg.mat');

% Excluding ignored channels
%exclude = any(isnan(params.data),2);
%params.data(exclude,:) = [];
%params.channels{exclude} = [];

chans = params.channels;

EEG.setname = filename;
EEG.data = params.data;
EEG.pnts = size(EEG.data,2);
EEG.nbchan = size(EEG.data,1);
%step = 1/params.srate;
%EEG.times = 0:step:(EEG.pnts-1)*step;
EEG.times = [];

%EEG.chanlocs(2:end) = [];
%for k=1:length(chans)
%    EEG.chanlocs(k) = get_chan( chans{k} );
%end
EEG.srate = params.srate;
evnts_file = fullfile(pwd, 'extra/events.txt');
EEG = eeg_checkset( EEG );
EEG = pop_importevent( EEG, 'event', evnts_file,'fields',{'number' 'latency' 'type' 'duration'},'skipline',1,'timeunit',NaN);
EEG = eeg_checkset( EEG );

% Checking if subdirectory exists
folder = fullfile('exports', fileparts(filename));
if ~isdir(folder), mkdir(folder); end

pop_writebva(EEG, ['exports/' filename]);

end


function chann = get_chan(label)

chann = struct( ...
    'labels', label, ...
    'ref', '', ...
    'theta', [], ...
    'radius', [], ...
    'X', [], ...
    'Y', [], ...
    'Z', [], ...
    'sph_theta', [], ...
    'sph_phi', [], ...
    'sph_radius', [], ...
    'type', '', ...
    'urchan', [] ...
    );
end