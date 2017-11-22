for nS = 1:length(config.subjs)
    subj = sprintf('SUBJ%03d', config.subjs(nS));
    
    sAccs  = accs(nS,:);
    blocks = mean( reshape(sAccs, 8, []), 2);
    runs = mean( reshape(blocks, 2, []) );
    
    sPercs = sprintf('%.2f%%\t', runs*100);
    %fprintf('%s%s\n', subj, sprintf('\t%.2f%%', runs*100));
    fprintf('%s\n', strrep(sPercs, '.', ','));
end