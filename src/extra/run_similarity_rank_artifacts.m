if isunix
    addpath( '/dados3/USERS/sebastian/My Documents/MATLAB/toolboxes/eeglab_svn' );
    rdir = '/dados1/PROJETOS/PRJ1210_EMOCODE/03_PROCS/EEG_GSR/WKSP/Raw Files';
    destdir = '/dados1/PROJETOS/PRJ1210_EMOCODE/03_PROCS/EEG_GSR/Trabalho_COB860/DADOS_DEMEAN_250';
else
    addpath( '\\10.36.4.201\dados3\Users\sebastian\My Documents\MATLAB\toolboxes\eeglab_svn' );
    rdir = 'Z:\PRJ1210_EMOCODE\03_PROCS\EEG_GSR\WKSP\Raw Files';
    destdir = 'Z:\PRJ1210_EMOCODE\03_PROCS\EEG_GSR\Trabalho_COB860\DADOS_DEMEAN_250';
end

fn_base  = 'PRJ1210_EMOCODE_20140214_SUBJ012_RUN';

eeglab

for r=1:4
   
    fname = sprintf( '%s%i.vhdr', fn_base, r );
    EEG = pop_loadbv( rdir, fname );
    EEG = pop_select( EEG, 'nochannel', { 'GSR_MR_100_left_hand', 'ECG' } );

%    EEG = pop_select( EEG, 'channel', { 'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'T7', 'C3', 'Cz', 'C4', 'T8', 'P7', 'P3', 'Pz', 'P4', 'P8', 'O1', 'O2' } );
%    EEG = pop_select( EEG, 'channel', { 'Fpz', 'F7', 'Fz', 'F8', 'T7', 'Cz', 'T8', 'P7', 'Pz', 'P8', 'Oz' } );

    EEG = pop_epoch( EEG, { 'R128' }, [0 2] );

    EEG = pop_select( EEG, 'notrial', [350] );

    [ a b scan_corr ] = similarity_rank_ga( EEG );
    
    % define outliers with an a-priori threshold
    scan_corr_sem_outliers = scan_corr;
    scan_corr_sem_outliers( scan_corr_sem_outliers  < 0.95 ) = [];
    
    % don't use scans with 3 std below mean
    corr_lim = mean( scan_corr_sem_outliers ) - 3*std(scan_corr_sem_outliers);
    
    scan_remove = find( scan_corr < corr_lim );
    
    EEG_good_scans = pop_select( EEG, 'notrial', scan_remove );
    
    if 0 % save uncorrected data

        EEG = transform_fft( EEG );
        EEG_good_scans = transform_fft( EEG_good_scans );
    
        EEG.data_freq_std = std( EEG.data_freq, [], 3 );
        EEG.data_freq = mean( EEG.data_freq, 3 );

        EEG_good_scans.data_freq_std = std( EEG_good_scans.data_freq, [], 3 );
        EEG_good_scans.data_freq = mean( EEG_good_scans.data_freq, 3 );
        
        save( fullfile( destdir,  ['EEG_RUN' num2str(r)]), 'EEG' );
        save( fullfile( destdir,  ['EEG_good_scans_RUN' num2str(r)]), 'EEG_good_scans' );
    
    else 
        EEG_20 = filter_gradient_artefacts( EEG, 20 );
        EEG_all = filter_gradient_artefacts( EEG, 348 );
        
        EEG_good_scans_20  = filter_gradient_artefacts( EEG_good_scans, 20 );
        EEG_good_scans_all = filter_gradient_artefacts( EEG_good_scans, size(EEG_good_scans.data,3)-1 );
        
        downsample = 1;
        if downsample
            EEG_20  = pop_resample( EEG_20 , 250 );
            EEG_all = pop_resample( EEG_all , 250 );
            EEG_good_scans_20  = pop_resample( EEG_good_scans_20 , 250 );
            EEG_good_scans_all = pop_resample( EEG_good_scans_all , 250 );
        end
        
        EEG_20 = transform_fft( EEG_20 );
        EEG_all = transform_fft( EEG_all );
        EEG_good_scans_20 = transform_fft( EEG_good_scans_20 );
        EEG_good_scans_all = transform_fft( EEG_good_scans_all );
        
        EEG_20.data_freq_std = std( EEG_20.data_freq, [], 3 );
        EEG_20.data_freq = mean( EEG_20.data_freq, 3 );
        
        EEG_all.data_freq_std = std( EEG_all.data_freq, [], 3 );
        EEG_all.data_freq = mean( EEG_all.data_freq, 3 );
        
        EEG_good_scans_20.data_freq_std = std( EEG_good_scans_20.data_freq, [], 3 );
        EEG_good_scans_20.data_freq = mean( EEG_good_scans_20.data_freq, 3 );
        
        EEG_good_scans_all.data_freq_std = std( EEG_good_scans_all.data_freq, [], 3 );
        EEG_good_scans_all.data_freq = mean( EEG_good_scans_all.data_freq, 3 );
        
        save( fullfile( destdir,  ['EEG_20_RUN' num2str(r)]), 'EEG_20' );
        save( fullfile( destdir,  ['EEG_all_RUN' num2str(r)]), 'EEG_all' );
        save( fullfile( destdir,  ['EEG_good_scans_20_RUN' num2str(r)]), 'EEG_good_scans_20' );
        save( fullfile( destdir,  ['EEG_good_scans_all_RUN' num2str(r)]), 'EEG_good_scans_all' );
    end
    
end