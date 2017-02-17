addpath( '\\10.36.4.201\dados3\Users\sebastian\My Documents\MATLAB\toolboxes\eeglab_svn' )

eeglab

rdir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\WKSP\Raw Files';
sdir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\GA_COB860';

fn_base  = 'PRJ1209_SAMBASYNC_20131130_SUBJ017_RUN';
fn_base  = 'PRJ1209_SAMBASYNC_20131204_SUBJ019_RUN';

fn_bases = {    'PRJ1209_SAMBASYNC_20131109_SUBJ003_RUN', ...
                'PRJ1209_SAMBASYNC_20131121_SUBJ011_RUN', ...
                'PRJ1209_SAMBASYNC_20131123_SUBJ013_RUN', ...
                'PRJ1209_SAMBASYNC_20131129_SUBJ016_RUN', ...
                'PRJ1209_SAMBASYNC_20131204_SUBJ019_RUN', ...
                'PRJ1209_SAMBASYNC_20140130_SUBJ020_RUN'};
    
for subj=1:length(fn_bases)

fn_base  = fn_bases{subj};

for r=1:2
   
    fname = sprintf( '%s%i.vhdr', fn_base, r );
    EEG = pop_loadbv( rdir, fname );
    
%    EEG = pop_select( EEG, 'nochannel', { 'GSR_MR_100_left_hand', 'ECG' } );

%    EEG = pop_select( EEG, 'channel', { 'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'T7', 'C3', 'Cz', 'C4', 'T8', 'P7', 'P3', 'Pz', 'P4', 'P8', 'O1', 'O2' } );
    EEG = pop_select( EEG, 'channel', { 'Fpz', 'F7', 'Fz', 'F8', 'T7', 'Cz', 'T8', 'P7', 'Pz', 'P8', 'Oz' } );

    EEG = pop_epoch( EEG, { 'R128' }, [0 2.5] );

    % delete last volume
    EEG = pop_select( EEG, 'notrial', [size(EEG.data,3)] );

    [ a b scan_corr ] = similarity_rank_ga( EEG );
    
    % define outliers with an a-priori threshold
    scan_corr_sem_outliers = scan_corr;
    scan_corr_sem_outliers( scan_corr_sem_outliers  < 0.95 ) = [];
    
    % don't use scans with 3 std below mean
    corr_lim = mean( scan_corr_sem_outliers ) - 3*std(scan_corr_sem_outliers);
    
    scan_remove = find( scan_corr < corr_lim );
    
    figure, plot( scan_corr ), 
    title( strrep( fname(28:end-4), '_', ' ' ) ), ylabel( 'Mean value of correlation with all other scans' ), xlabel( 'scan' )
    hold on, plot( xlim, repmat(corr_lim,1,2) ,'r' ), plot( scan_remove, scan_corr(scan_remove), 'ro' )
    
    subdir = fname(28:end-4);
    ssdir = fullfile( sdir, subdir );
    if ~isdir( ssdir ), mkdir( ssdir ); end
        
    set(gcf,'units','normalized','outerposition',[0 0 1 1],'PaperPositionMode', 'auto' )
    saveas( gcf, fullfile( ssdir, [fname(28:end-4) num2str(r) '_correlacao.png' ]) )

    
    EEG_good_scans = pop_select( EEG, 'notrial', scan_remove );
    
%    if 1 % save uncorrected data

        EEG = transform_fft( EEG );
        EEG_good_scans = transform_fft( EEG_good_scans );
    
        EEG.data_freq_std = std( EEG.data_freq, [], 3 );
        EEG.data_freq = mean( EEG.data_freq, 3 );

        EEG_good_scans.data_freq_std = std( EEG_good_scans.data_freq, [], 3 );
        EEG_good_scans.data_freq = mean( EEG_good_scans.data_freq, 3 );
        
        
        
        save( fullfile( ssdir,  ['EEG_RUN' num2str(r)]), 'EEG' );
        save( fullfile( ssdir,  ['EEG_good_scans_RUN' num2str(r)]), 'EEG_good_scans' );
    
 %   else 
        EEG_20 = filter_gradient_artefacts( EEG, 20 );
        EEG_all = filter_gradient_artefacts( EEG, 348 );
        
        EEG_good_scans_20  = filter_gradient_artefacts( EEG_good_scans, 20 );
        EEG_good_scans_all = filter_gradient_artefacts( EEG_good_scans, size(EEG_good_scans.data,3)-1 );
        
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
        
            
        save( fullfile( ssdir,  ['EEG_20_RUN' num2str(r)]), 'EEG_20' );
        save( fullfile( ssdir,  ['EEG_all_RUN' num2str(r)]), 'EEG_all' );
        save( fullfile( ssdir,  ['EEG_good_scans_20_RUN' num2str(r)]), 'EEG_good_scans_20' );
        save( fullfile( ssdir,  ['EEG_good_scans_all_RUN' num2str(r)]), 'EEG_good_scans_all' );
  %  end
    
end

end