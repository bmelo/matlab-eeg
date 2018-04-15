% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
[~, rootdir] = fileattrib('../../..');
addpath( rootdir.Name );
init_app;

sizes = [.5 1 1.5 2 3 4];
pool = parpool('local', 6);
parfor nS = 1:length(sizes)
    test_window(sizes(nS));
end
delete(pool);