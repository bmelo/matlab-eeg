function group = grand_average_patt( config, filepatt )
%GRAND_AVERAGE 
% Do grand average with a given pattern

% General variables
save_dir = fullfile( config.imgsexport_dir, 'grand_avg' );
conds = {'TASK_T' 'TASK_A'};
plot_title = 'Grand Average ERD/ERS';

fprintf('\n####   GRAND AVERAGE   ####\n\n');
for k = 1:nFiles
    file = filepatt{k};
    group(k) = group_matrix(config, file);
end

% Ending main function
end