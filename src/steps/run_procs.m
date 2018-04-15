function run_procs(config )
import utils.Var

%% PREPROC
if Var.get(config.preproc, 'active')
    preproc(config);
end

%% Visual Check
if Var.get(config, 'visual_check')
    visual_check(config);
end

%% PROC
% Features extraction
if Var.get(config.proc.features, 'active')
    extract_features(config);
end

% Grand Average
if Var.get(config.proc, 'grand_average')
    grand_average( config );
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