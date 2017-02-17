rdir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\WKSP\Raw Files'; 
fname = 'PRJ1209_SAMBASYNC_20131204_SUBJ019_RUN1.vhdr';

EEG = pop_loadbv( rdir, fname );
    
EEG = pop_select( EEG, 'nochannel', { 'GSR_MR_100_left_hand', 'ECG' } );
    
EEG_R128 = pop_epoch( EEG, { 'R128' }, [0 2.5] );
    
similarity_rank_ga( EEG_R128 );