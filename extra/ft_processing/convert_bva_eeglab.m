if ~exist( 'pop_loadbva' )
    addpath( genpath( '\\10.36.4.201\dados3\USERS\sebastian\My Documents\MATLAB\toolboxes\eeglab_svn' ) );
end

init_fieldtrip


data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\WKSP\Export\COMPLETE_RUNS';

dest_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Reref_CPz';

if ~isdir( dest_dir ), mkdir( dest_dir ), end;

subjs = [3 11 13 16 17 19];

% loop over subjects
for s=1:length(subjs)
    
    % loop over runs
    for r=1:2

        fname = sprintf( 'SUBJ%03i_RUN%i_Reref_Avg', subjs(s), r ) ;
        eeg = pop_loadbva( fullfile( data_dir, [fname '.mat'] ) );
        
        % rereference to Oz
        ch_ind = find( strcmp( {eeg.chanlocs.labels }, 'CPz' ) );
        eeg = pop_reref( eeg, ch_ind );  
        fname = [fname(1:end-3) 'CPz'];
        
        pop_saveset( eeg, 'filename', fname, 'filepath', dest_dir );
        
    end
end