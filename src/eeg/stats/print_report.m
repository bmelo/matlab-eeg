function print_report( EEG, results )
%PRINT_REPORT Summary of this function goes here
%   Detailed explanation goes here

labels = {EEG.chanlocs(:).labels};

if isstruct(results)
    fprintf('\nTernura vs Neutro\n');
    list = sprintf('%s ', labels{results.T_N == 1});
    disp(list);
    
    fprintf('\nAngústia vs Neutro\n');
    list = sprintf('%s ', labels{results.A_N == 1});
    disp(list);
    
    fprintf('\nTernura vs Angústia\n');
    list = sprintf('%s ', labels{results.T_A == 1});
    disp(list);
else
    list = sprintf('%s ', labels{results == 1});
    disp(list);
end

end

