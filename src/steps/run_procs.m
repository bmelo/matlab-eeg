function run_procs(config )

%% Preproc
if config.do_preproc
    preproc(config);
end

%% Grand Average
if config.do_grand_average
    files = config.gavg_files;
    for nF = 1 : length(files)
        grand_average( config, files{nF} );
    end
end

%% Visual Check
if config.do_visual_check
    visual_check(config);
end

%% FIRST LEVEL
if config.do_first_level
    first_level(config);
end

%% Group processing
if( config.do_second_level )
    second_level(config);
end

end