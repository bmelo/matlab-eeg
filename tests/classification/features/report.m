function report()

features = {
    {'l_erders_feats'}
    {'l_power_feats'}
    {'l_power_rel_feats'}
    {'l_dens_feats'}
    {'l_power_feats' 'l_power_rel_feats' 'l_dens_feats'}
    {'l_erders_feats' 'l_power_feats' 'l_power_rel_feats' 'l_dens_feats'}
};


for nF = 1:length(features)
    str_feats = strjoin(features{nF}, '-');
    load( sprintf('%s/accs_feature_%s', 'FEATURES', str_feats) );
    
    medians = median(accs, 2);
    for m = medians'
        fprintf('%04d\t%.4f\n', nF, m);
    end
end

end