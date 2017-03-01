

%% dirs
subdir = 'Sinc_Asinc_TR_1_100Hz_toi_0_20';
subdir = 'Music_Rating_TR_1_100Hz';
data_classify = {fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\', subdir, '\Freq\baseline_mean_trial') , 'EX_TRIAL_baseline_mean_trial_'};
data_classify = {fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\', subdir, '\Freq\baseline') , 'EX_TRIAL_baseline_'};

%% subjects
subjs = [3 11 13 16 17 19];

config = [];
%%
config(1).chan_cmb = { 'F3' 'C3'; 'C3' 'P3'; 'F3' 'P3'; 'F4' 'C4'; 'C4' 'P4'; 'F4' 'P4'; 'Fz' 'Cz'; 'Cz' 'Pz'; 'Fz' 'Pz';};
config(1).freq_cmb = [];
config(1).op = '-';
config(1).name = [data_classify{1,2} 'anterior_posterior_diff'];

%%
config(2).chan_cmb = { 'F3' 'F4'; 'C3' 'C4'; 'P3' 'P4'; 'FC3' 'FC4'; 'CP3' 'CP4'; };
config(2).freq_cmb = [];
config(2).op = '-';
config(2).name = [data_classify{1,2} 'hemisphere_diff'];
%%
config(3).chan_cmb = [];
config(3).freq_cmb = [];
config(3).op = '-';
config(3).name = [data_classify{1,2} 'all_channels_diff'];

%%
config(4).chan_cmb = 'left-right';
config(4).freq_cmb = [];
config(4).op = '-';
config(4).name = [data_classify{1,2} 'left_right_diff'];

config(3) = [];

for con=1:length(config)
    
    chan_cmb = config(con).chan_cmb;
    freq_cmb = config(con).freq_cmb;
    op       = config(con).op;
    name     = config(con).name
    
    % loop over subjects
    for s=1:length(subjs)
        
        
        fname = sprintf( 'SUBJ%03i.mat', subjs(s) ) ;
        
        load( fullfile(data_classify{1,1}, fname) )
        
        fprintf( 'SUBJECT %i\n', subjs(s) )
        
        data = combinar_features( data, chan_cmb, freq_cmb, op);
        
        res(s).accuracy = train_classify_SVM_excluding_trial_folds( data.x, data.y, data.x_desc );
        
        %res(s).accuracy = train_classify_SVM( data.x, data.y );
        res(s).subject = subjs(s);
        res(s).config.chan_filtro = chan_cmb;
        res(s).config.freq_filtro = freq_cmb;
        res(s).config.name = name;
        res(s).data = data;
        
    end
    
    save( fullfile( data_classify{1,1}, ['results_' name '.mat']), 'res' );
    
end