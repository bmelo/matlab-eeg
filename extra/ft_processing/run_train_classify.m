
dirs_classify = { ...
    'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\Sinc_Asinc\Freq\baseline_mean_trial\'               , 'baseline_mean_trial_'; ...
    'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\Sinc_Asinc\Freq\mean_trial\'                        , 'mean_trial_'; ...
    'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\Sinc_Asinc\Freq_Embaralhado\baseline_mean_trial\'   , 'EMB_baseline_mean_trial_'; ...
    'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\Sinc_Asinc\Freq_Embaralhado\mean_trial\'            , 'EMB_mean_trial_'; ...
    'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\Sinc_Asinc\Freq\'                                   , ''; ...
    'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\Sinc_Asinc\Freq\baseline\'                          , 'baseline_'; ...
    'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\Sinc_Asinc\Freq_Embaralhado\'                       , 'EMB_'; ...
    'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\Sinc_Asinc\Freq_Embaralhado\baseline\'              , 'EMB_baseline_'; ...
    'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\Sinc_Asinc\Freq_Embaralhado2\baseline\'             , 'EMB2_baseline_'; ...
    };

% subdir = 'Sinc_Asinc_TR_1_100Hz_Z';
% subdir = 'Music_Rating_TR_1_100Hz_Z';
subdir = 'Sinc_Asinc_TR_1_100Hz_toi_0_20_Z';
% subdir = 'As0_As83_TR_1_100Hz_toi_0_20'; %% very bad

dirs_classify = { ...
%    fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\', subdir, '\Freq\baseline_mean_trial\')               , 'baseline_mean_trial_'; ...
%    fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\', subdir, '\Freq\mean_trial\')                        , 'mean_trial_'; ...
%     fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\', subdir, '\Freq_Embaralhado\baseline_mean_trial\')   , 'EMB_baseline_mean_trial_'; ...
%     fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\', subdir, '\Freq_Embaralhado\mean_trial\')            , 'EMB_mean_trial_'; ...
    fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\', subdir, '\Freq\')                                   , ''; ...
%    fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\', subdir, '\Freq\baseline\')                          , 'baseline_'; ...
%   fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\', subdir, '\Freq_Embaralhado\')                       , 'EMB_'; ...
  %  fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\', subdir, '\Freq_Embaralhado\baseline\' )             , 'EMB_baseline_'; ...
   %fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\', subdir, '\Freq_Embaralhado2\baseline\')             , 'EMB2_baseline_'; ...
    };
% dirs_classify = dirs_classify(end,:);

% dirs_classify = { ...
%     'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\Sinc_Asinc\Freq_Embaralhado2\baseline\'              , 'EMB2_baseline_'; ...
%     };

% subdir = 'Music_Rating_TR_1_100Hz';
% %subdir = 'Music_Rating_TR';
% dirs_classify = { ...
%      fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\',subdir,'\Freq\baseline_mean_trial\' )              , 'baseline_mean_trial_'; ...
%      fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\',subdir,'\Freq\mean_trial\'          )              , 'mean_trial_'; ...
%      fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\',subdir,'\Freq\'                     )              , ''; ...
%      fullfile('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_Reref_Oz\Classify\',subdir,'\Freq\baseline\'            )              , 'baseline_'; ...
%      };
 
%  dirs_classify = dirs_classify(3,:); 

for d=1:size(dirs_classify,1)
    
    data_classify = dirs_classify{d,1};
    
    %% subjects
    subjs = [3 11 13 16 17 19];
    
    config = [];
    res    = [];
 
%      config(1).chan_filtro = [];
%      config(1).freq_filtro = [];
%      config(1).name = [dirs_classify{d,2} 'best_25'];
  
        config(1).chan_filtro = [];
        config(1).freq_filtro = [];
        config(1).name = [dirs_classify{d,2} 'all_freqs_all_electrodes'];

%         %%
%         config(2).chan_filtro = { 'C1', 'C3', 'FC1', 'FC3', 'CP1', 'CP3' };
%         config(2).freq_filtro = { 'F8a13Hz' };
%         config(2).name = [dirs_classify{d,2} 'alpha_left_central'];
%         
%         %%
%         config(3).chan_filtro = [];
%         config(3).freq_filtro = { 'F8a13Hz' };
%         config(3).name = [dirs_classify{d,2} 'alpha_all_electrodes'];
%     
    for conf = 1:length(config)
        
        chan_filtro = config(conf).chan_filtro;
        freq_filtro = config(conf).freq_filtro;
        name        = ['EX_TRIAL_' config(conf).name]
        
        % loop over subjects
        for s=1:length(subjs)
            
            
            fname = sprintf( 'SUBJ%03i.mat', subjs(s) ) ;
            
            load( fullfile(data_classify, fname) )
            
            fprintf( 'SUBJECT %i\n', subjs(s) )
            
            data = filtrar_features( data, chan_filtro, freq_filtro );

            if ~isempty( strfind( config(conf).name, 'best_25' ) )
                [data data_25] = rank_features( data );
                data = data_25;
            end
            % data = filtrar_adjacent_window_trials( data );
            
            % res(s).accuracy = train_classify_SVM( data.x, data.y );
            
            res(s).accuracy = train_classify_SVM_excluding_trial_folds( data.x, data.y, data.x_desc );
            
            res(s).subject = subjs(s);
            res(s).config.chan_filtro = chan_filtro;
            res(s).config.freq_filtro = freq_filtro;
            res(s).data = data;
            
        end
        
        save( fullfile( data_classify, ['results_' name '.mat']), 'res' );
        
    end
end