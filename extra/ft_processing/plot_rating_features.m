d = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Regress\ClinicalBands_toi_0_20\Freq\baseline_mean_trial';

d = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\Music_Rating\Freq\mean_trial';
%load( 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\Music_Rating_TR_1_100Hz\Freq\baseline_mean_trial\results_EX_TRIAL_baseline_mean_trial_all_freqs_all_electrodes.mat' )
load( 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\Classify\Music_Rating_TR_1_100Hz\Freq\mean_trial\results_EX_TRIAL_mean_trial_all_freqs_all_electrodes.mat' )

z = 1;

% subjects
subjs = [3 11 13 16 17 19];

figure

for s=1:length(subjs)
   
    fname = sprintf( 'SUBJ%03i', subjs(s) );
    
    load( fullfile( d, fname ) );
    
    if z
        x = zscore(data.x);
    else
        x = data.x;
    end
    
    % delete rows if 10% of the features is > 3*Std 
    out_inds = sum( abs(x) > 3, 2 ) > 0.05 * size(x,1) ;
    out_inds = zeros(size(x,1),1) == 1;
    % x = abs(x) > 3 ;
    
    fprintf( 'Removing %i outliers of %i for %s\n', sum(out_inds), length(out_inds), fname )
    
    data.y(out_inds) = [];
    x( out_inds, : ) = [];
    
    [y ind] = sort( data.y, 1, 'ascend' );

    
    subplot(length(subjs),1,s)
    % imagesc( [x(ind,:) zscore(y)] );
    imagesc( [x(ind,:) ] );
    if length( unique( y ) ) == 2 
        y_units = unique( y );
        a = find( y == y_units(2) );
        hold on, plot( xlim, [ a(1) a(1) ] , 'k', 'Linewidth', 2)
    end
    colorbar
    if z
        caxis( [ -2 2 ] );
    elseif strfind( d, 'baseline' )
        caxis([0 2]);
    else
        caxis( [0 15] );
    end
    
    title( [fname ' - ' num2str(res(s).subject) ' - Acuracy: ' sprintf( '%.2f', res(s).accuracy) ] );
    
    last_lab = data.features.desc{1}( strfind( data.features.desc{1}, '_' ) + 1 : end );
    lastm = 1;
    ticks = [];
    labs  = [];
    for k=2:length(data.features.desc)
        m = strfind( data.features.desc{k}, '_' );
        curr = data.features.desc{k}(m+1:end);
        
        if ~strcmp( curr ,last_lab )
            labs{end+1}  = last_lab;
            ticks(end+1) = lastm + (k-lastm) / 2;
            lastm = k;
            last_lab = curr;
        end
    end
    labs{end+1}  = curr;
    ticks(end+1) = lastm + (k-lastm) / 2;
    
    set( gca, 'xtick', ticks, 'xticklabel', labs );
    
    
end