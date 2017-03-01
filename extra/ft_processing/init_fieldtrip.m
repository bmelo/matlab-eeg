if ~exist( 'initialized', 'var' ) 
    
    exclude = 'fieldtrip';
    add_dir = '\\10.36.4.201\dados3\Users\sebastian\My Documents\MATLAB\toolboxes\fieldtrip-20131208';
    
    addpath( '\\10.36.4.201\dados3\USERS\sebastian\My Documents\MATLAB\SCRIPTS-EEG\util' );
    remove_from_path( exclude, add_dir );
    
    initialized = true;

end