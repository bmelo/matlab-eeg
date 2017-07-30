function grand_average( config, filepatt )

% General variables
save_dir = fullfile( config.imgsexport_dir, 'grand_avg' );
conds = {'TASK_T' 'TASK_A'};
plot_title = 'Grand Average ERD/ERS';

fprintf('\n####   GRAND AVERAGE   ####\n\n');
for k = 1:nFiles
    file = filepatt{k};
    group(k) = group_matrix(config, file);
    
    % Plotting matrices
    label = extract_label(file);
    plot_matrix(group(k).mean.TASK_T, group(k).srate, group(k).channels);
    suptitle( sprintf('%s - TASK_T', label) );
    export_img(save_dir, sprintf('%s - TASK_T.png', file));
        
    plot_matrix(group(k).mean.TASK_A, group(k).srate, group(k).channels);
    suptitle( sprintf('%s - TASK_A', label) );
    export_img(save_dir, sprintf('%s - TASK_A.png', file));
end

% Ending main function
end