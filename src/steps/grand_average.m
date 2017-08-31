function grand_average( config )

prefixes = config.proc.gavg_prefix;

fprintf('\n####   GRAND AVERAGE   ####\n\n');
for k = 1:length(prefixes)
    file = gen_filename( filepatt, config.bands(k,:) );
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