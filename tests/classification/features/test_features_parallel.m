% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
[~, rootdir] = fileattrib('../../..');
addpath( rootdir.Name );
init_app;

features = {
    {'l_erders_feats'}
    {'l_power_feats'}
    {'l_power_rel_feats'}
    {'l_dens_feats'}
    {'l_power_feats' 'l_power_rel_feats' 'l_dens_feats'}
    {'l_erders_feats' 'l_power_feats' 'l_power_rel_feats' 'l_dens_feats'}
};

pool = parpool('local', 6);
parfor nF = 1:length(features)
    test_features(features{nF});
end
delete(pool);