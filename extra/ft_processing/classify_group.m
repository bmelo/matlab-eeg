d = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\Sinc_Asinc\Freq\baseline_mean_trial\';

d = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\Music_Rating\Freq\mean_trial\';

%% subjects
subjs = [3 11 13 16 17 19];

x = [];
y = [];

% loop over subjects
for s=1:length(subjs)
    
    
    fname = sprintf( 'SUBJ%03i.mat', subjs(s) ) ;
    
    load( fullfile(d, fname) )
    
    x = [ x ; data.x ];
    y = [ y ; data.y ];
    
end

accuracy = train_classify_SVM( x, y )
