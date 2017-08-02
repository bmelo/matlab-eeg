function run_procs(config )
import utils.Var

%% PREPROC
if Var.get(config.preproc, 'active')
    preproc(config);
end

%% Visual Check
if Var.get(config.proc.features, 'active')
    extract_features(config);
end

%% PROC
% Grand Average
if Var.get(config.proc, 'grand_average')
    prefixes = config.proc.gavg_prefix;
    for nF = 1 : length(prefixes)
        run_grand_averages( config, prefixes{nF} );
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