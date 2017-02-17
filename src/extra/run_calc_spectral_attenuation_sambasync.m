%addpath( '\\10.36.4.201\dados3\Users\sebastian\My Documents\MATLAB\toolboxes\eeglab_svn' )

%eeglab
clear att;
clear mean_chan_att;

rootdir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\GA_COB860';

subjs = [ 3 11 13 16 20];

for subj=1:length(subjs)
    
rdir = fullfile(rootdir, sprintf( 'SUBJ%03i', subjs(subj) ) );
tit = sprintf( 'SUBJECT %i', subjs(subj) );

files_before_after = {  ...
    %'EEG_RUN' 'EEG_20_RUN'; ...
    %'EEG_RUN' 'EEG_all_RUN'; ...
    'EEG_good_scans_RUN' 'EEG_good_scans_20_RUN'; ...
    'EEG_good_scans_RUN' 'EEG_good_scans_all_RUN'; ...
};
% files_before_after = {  ...
%     'EEG_RUN' 'EEG_good_scans_RUN' };

binsize = 0.5;
freqs = 32:16:100;
%freqs = 64;
freqs = [freqs-binsize , freqs+binsize];

num_runs = 2;

for v=1:size(files_before_after,1)
    
    for r=1:num_runs
        
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
    for r=1:2
        mean_chan_att(v,r) = mean( att(v,r).att );
    end
end

figure
bar( mean_chan_att' ), legend( strrep( files_before_after(:,2), '_', ' ' ) )
set(gca, 'xticklabel', {'RUN1', 'RUN2'} )
title( ['Attenuation of gradient artifact - ' tit ] )
set(gcf,'units','normalized','outerposition',[0 0 1 1],'PaperPositionMode', 'auto' )
saveas( gcf, fullfile( rdir, 'attenuation_32_16_100Hz.png' ) )

end
%saveas( gcf, fullfile( rdir, 'comparison_all_vs_good_before.png' ) )
