clear all
subdir = 'Music_Rating_TR_1_100Hz';
%subdir = 'Music_Rating_TR';
% dirs = {
%     fullfile( 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir,'\Freq\baseline_mean_trial')  , 'baseline_mean_trial_'; ...
%     fullfile( 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir,'\Freq\mean_trial'         )  , 'mean_trial_' ;...
%     fullfile( 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir,'\Freq\baseline'           )  , 'baseline_';...
%     fullfile( 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir,'\Freq'                    )  , '' ;...
%     };
% tit = 'Music vs Rating';


 tit = 'Sinc vs Asinc';

 subdir = 'Sinc_Asinc_TR_1_100Hz_toi_0_20';
 subdir = 'Sinc_Asinc_TR_1_100Hz';
 
dirs = { ...
%     fullfile( 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir,'\Freq\baseline_mean_trial\')              , 'baseline_mean_trial_'; ...
%     fullfile( 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir,'\Freq\mean_trial\'         )               , 'mean_trial_'; ...
    fullfile( 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir,'\Freq\baseline\'           )               , 'baseline_'; ...
    fullfile( 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir,'\Freq\'                    )               , ''; ...
%     fullfile( 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir,'\Freq_Embaralhado\baseline_mean_trial\')   , 'EMB_baseline_mean_trial_'; ...
%     fullfile( 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir,'\Freq_Embaralhado\mean_trial\'         )   , 'EMB_mean_trial_'; ...
    fullfile( 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir,'\Freq_Embaralhado\baseline\'           )   , 'EMB_baseline_'; ...
    fullfile( 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\',subdir,'\Freq_Embaralhado\'                    )   , 'EMB_'; ...
    };

ind = 1;
for k=1:length(dirs)
   
    fs = dir( fullfile( dirs{k}, 'results_EX_TRIAL*' ) );
    
    for f=1:length(fs)
       
        load( fullfile( dirs{k}, fs(f).name ) );
        
        m(ind) = mean( [res.accuracy] );
        s(ind) = std(  [res.accuracy] );
        
        
        for sub=1:length(res)
            num_pts_subj(sub) = size(res(sub).data.x,1);
        end
        num_pts(ind) = mean(num_pts_subj);
    
        if isfield( res, 'name' )
            name{ind} = res(1).name
        else
            name{ind} = fs(f).name;
        end
        
        if strfind( name{ind}, 'results' ) == 1, name{ind} = name{ind}(8:end); end
        if ~isempty( strfind( name{ind}, '.mat' ) ), name{ind} = name{ind}(1:end-4); end
        a = strfind( name{ind}, '_' );
        if ~isempty(a) && a(1) == 1, name{ind} = name{ind}(2:end); end
        
        if strfind( name{ind}, 'EX_TRIAL' ) == 1, name{ind} = name{ind}(9:end); end

       % if strfind( name{ind}, '_baseline' ) == 1, name{ind} = name{ind}(10:end); end

        name{ind} = strrep( name{ind}, '_', ' ' );

        num_feat(ind) = size( res(1).data.x, 2 );

        if 1,
            figure,
            bar([res.accuracy])
            title([name{ind} ' (' sprintf('%d',round(num_pts(ind))) ',' num2str(num_feat(ind)) ')'] )
            set(gca, 'xtick', 1:length(res), 'xticklabel', cellfun( @(x) ['S' num2str(x)],  { res.subject }, 'UniformOutput', false)  )
            ylabel('Classification accuracy - Leave-one-out')
        end

        
        ind = ind+1;
    end
end

sel = 1:length(m); 
% sel = [1 2 3 4 6];
% sel = [1 2 3 4 6 11 12 13 14 16];

sel = [5 6 7 16 17 18];

m = m(sel);
s = s(sel);
name = name(sel);
num_pts = num_pts(sel);
num_feat = num_feat(sel);

figure,
bar( m ), hold on
for k=1:length(m), 
    errorbar( k, m(k), s(k), 'k' ),     
    name{k} = [ name{k} ' (' sprintf('%d',round(num_pts(k))) ',' num2str(num_feat(k)) ')' ];
end
ylim( [0 1] )
ylabel( 'Classification accuracy - Leave-one-out' )
set(gca, 'xtick',1:length(name), 'xticklabel', name );
view(90,90)
title( sprintf('%s\n%i subjects', tit, length(res) ) )

