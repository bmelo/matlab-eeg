function run_procs(config )
import utils.Var

%% PREPROC
if Var.get(config.proc.pre, 'active')
    preproc(config);
    
    %% Visual Check
    if Var.get(config.proc.pre, 'visual_check')
        visual_check(config);
    end
end

%% PROC
% Grand Average
if Var.get(config.proc, 'grand_average')
    files = config.proc.gavg_files;
    for nF = 1 : length(files)
        grand_average( config, files{nF} );
    end
end

%% STATS
% FIRST LEVEL
if Var.get(config.stats, 'first_level')
    first_level(config);
end

% Group processing
if Var.get(config.stats, 'second_level')
    second_level(config);
end

end