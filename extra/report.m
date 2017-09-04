function medians = report( folder )

patt_results = fullfile( folder, '*.mat' );
files = sort( utils.resolve_names( patt_results ) );
medians = [];

for nF = 1:length(files)
    filename = files{nF};
    load( files{nF} );
    line_num = str2num( regexp(filename, '(?<=acc_)\d{2}', 'match', 'once') );
    
    medians(line_num,:) = median(accs,2);
end

% Displaying results
for nR = 1:size(medians, 1)
    for nC = 1:size(medians, 2)
        sM = strrep( sprintf('%.4f', medians(nR, nC)), '.', ',' );
        fprintf('%s\t', sM);
    end
    fprintf('\n');
end

%% PLOTTING
ignore = [1 2 13 14];
%ignore = [1 2 13 14 15 16 26 30 38 49 52 55 56 57 59 61];
chs = setdiff(1:63, ignore);

figure;
medians( medians < .34 ) = NaN;
means = nanmean( medians, 2 );
means(ignore) = NaN;
limits =  [min(means) max(means)];
load('channels_location');
topoplot(means, chanlocs, 'maplimits', limits, 'electrodes', 'ptsnumbers'); 
cbar('vert',1, limits);