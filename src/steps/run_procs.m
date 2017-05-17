function run_procs(config )
import utils.Var

%% Preproc
if Var.get(config, 'do_preproc')
    preproc(config);
end

%% Visual Check
if Var.get(config, 'do_visual_check')
    visual_check(config);
end

%% Grand Average
if Var.get(config, 'do_grand_average')
    files = config.gavg_files;
    for nF = 1 : length(files)
        grand_average( config, files{nF} );
    end
end

%% FIRST LEVEL
if Var.get(config, 'do_first_level')
    first_level(config);
end

%% Group processing
if Var.get(config, 'do_second_level')
    second_level(config);
end

end