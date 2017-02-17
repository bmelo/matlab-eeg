%addpath( '\\10.36.4.201\dados3\Users\sebastian\My Documents\MATLAB\toolboxes\eeglab_svn' )

%eeglab

rdir = 'Z:\PRJ1210_EMOCODE\03_PROCS\EEG_GSR\Trabalho_COB860\DADOS';

fn_base  = 'PRJ1210_EMOCODE_20140214_SUBJ012_RUN';

files_before_after = {  ...
    'EEG_RUN' 'EEG_20_RUN'; ...
    'EEG_RUN' 'EEG_all_RUN'; ...
    'EEG_good_scans_RUN' 'EEG_good_scans_20_RUN'; ...
    'EEG_good_scans_RUN' 'EEG_good_scans_all_RUN' };

binsize = 0.5;
freqs = 25:12.5:100;
freqs = [freqs-binsize , freqs+binsize];

for v=1:size(files_before_after,1)
    
    for r=1:4
        
        fn_base = files_before_after{v,1};
        fname = sprintf( '%s%i.mat', fn_base, r );
        a = load( fullfile( rdir, fname ) );
        fields = fieldnames(a);
        EEG_unc = a.(fields{1});
        
        fn_base = files_before_after{v,2};
        fname2 = sprintf( '%s%i.mat', fn_base, r );
        a = load( fullfile( rdir, fname2 ) );
        fields = fieldnames(a);
        EEG_corr = a.(fields{1});

        att(v,r) = calc_spectral_attenuation( EEG_unc, EEG_corr, freqs );

    end
    
end


for v=1:size(files_before_after,1)
    for r=1:4
        mean_chan_att(v,r) = mean( att(v,r).att );
    end
end

figure
plot( mean_chan_att' ), legend( files_before_after(:,2) )
