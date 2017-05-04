function run_procs(config )

%% Preproc
if config.do_preproc
    preproc(config);
end

%% Visual Check
if config.do_visual_check
    visual_check;
end

%% FIRST LEVEL
if config.do_first_level
    first_level;
end

%% Group processing
if( config.do_second_level )
    second_level;
end

end