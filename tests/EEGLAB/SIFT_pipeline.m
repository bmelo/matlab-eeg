function SIFT_pipeline()
% By Bruno Melo <bruno.melo@idor.org>
init_app;

rawdir = '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/RAW_DATA/EEG/';
outdir = '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/PREPROC_DATA/EEG/EEGLAB/CONN';

% PREPROC
if 0
    matlabpool open local 8
    subjs = setdiff([1 2 4:14], []);
    parfor k=1:length(subjs)
        eeglab_preproc(subjs(k), rawdir, outdir);
    end
    matlabpool close
    eeglab_preproc(15, rawdir, outdir, 1:63);
end
end


%% PREPROC STEPS
function eeglab_preproc( nsub, rawdir, outdir, chs )
if nargin < 4, chs = [1:31 33:64]; end;

subjid = sprintf('SUBJ%03d', nsub);

filein = utils.resolve_name( fullfile(rawdir, subjid, sprintf('SUBJ*%02d.vhdr', nsub)) );
fprintf('%s [%s]\n', subjid, filein);

EEG = pop_loadbv(fileparts(filein), utils.path.basename(filein),[], chs);
EEG.event = clear_bad_events(EEG.event);
EEG.setname = subjid;
EEG = eeg_checkset( EEG );
EEG = pop_resample( EEG, 500);
EEG = eeg_checkset( EEG );
EEG = pop_chanedit( EEG, 'lookup', '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/SCRIPTS/EEG/matlab-eeg/vendors/eeglab-14.1/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp');
EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, []);
EEG.setname = [subjid '_preproc'];
EEG = eeg_checkset( EEG );
tEEG = pop_epoch( EEG, { 'S  2' }, [-10  56], 'newname', [EEG.setname '_T'], 'epochinfo', 'yes');
tEEG = eeg_checkset( tEEG );
pop_saveset(tEEG, [subjid '_T.set'], outdir);
aEEG = pop_epoch( EEG, { 'S  3' }, [-10  56], 'newname', [EEG.setname '_A'], 'epochinfo', 'yes');
aEEG = eeg_checkset( aEEG );
pop_saveset( aEEG, [subjid '_A.set'], outdir);
%ALLEEG = EEG;
end

%EEG = pop_loadset('filename', [subjid '_epochs.set'],'filepath',outdir);