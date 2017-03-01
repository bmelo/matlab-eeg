init_fieldtrip

data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT';
dest_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\TimeFreqPlots';
dest_dir_data = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\TimeFreqData';

subjs = [3 11 13 16 17 19];

% loop over subjects
for s=1:length(subjs)
    
    % loop over runs
    for r=1:2

        fname = sprintf( 'SUBJ%03i_RUN%i_Reref_Avg.set', subjs(s), r ) ;
            
        trial_groups = { { 'S 10', 'S 20', 'S 30', 'S 11', 'S 21', 'S 31' } , ...
            { 'S 12', 'S 22', 'S 32', 'S 13', 'S 23', 'S 33' } };
        group_names = {'SINC' , 'ASINC' };
            
        
        for g=1:length( trial_groups )
            
            cfg = [];
            cfg.trialdef.prestim  = 5;                 % in seconds
            cfg.trialdef.poststim = 25; 
            cfg.trialdef.eventtype = 'trigger';           % use ‘?’ to get a list of the available types
            cfg.trialdef.eventvalue = trial_groups{g};
            cfg.dataset = fullfile( data_dir, fname );
            cfg = ft_definetrial(cfg)
            trialdata = ft_preprocessing(cfg);	% call preprocessing, putting the output in ‘trialdata’

            cfg.artfctdef.reject = 'partial'; 
            cfg.artfctdef.zvalue.channel    = 'EEG';
            cfg.artfctdef.zvalue.cutoff     = 3;
            cfg.artfctdef.zvalue.trlpadding = 0;
            cfg.artfctdef.zvalue.artpadding = 0;
            cfg.artfctdef.zvalue.fltpadding = 0;
            cfg.artfctdef.feedback='yes',

            [cfg artifact] = ft_artifact_zvalue( cfg, trialdata );

            data_no_artifacts = ft_rejectartifact(cfg,trialdata);

            cfg = [];
            cfg.output         = 'pow';
            cfg.method         = 'mtmconvol';
            cfg.taper          = 'hanning';
            cfg.foi            = 1:30;
            cfg.t_ftimwin      = 2.5*ones(1,length(cfg.foi)); % window length: 2.5s
            cfg.toi            = -5:1:25;
            %cfg.keeptrials     = 'yes';
            
            freq               = ft_freqanalysis(cfg, data_no_artifacts);
            freq.elec          = trialdata.elec;

            freqs = [4 8; 8 13; 13 20];
            
            %fns = sprintf( 'SUBJ%03i_RUN%i_%s.mat', subjs(s), r, group_names{g} );
            
            %save( fullfile(dest_dir_data, fns) , 'freq' );
            
            
            for f=1:size(freqs,1)
                
                cfg = [];
                cfg.xlim = [-5:2.5:25];
                cfg.ylim = freqs(f,:);
                cfg.zlim = [0.5 1.5];
                cfg.baseline = [-5 0];
                cfg.baselinetype = 'relative';
                cfg.comment = 'xlim';
                cfg.commentpos = 'title';
                cfg.colorbar = 'no';
                cfg.interactive = 'yes';
                figure; 
                ft_topoplotTFR(cfg, freq)

                pos = get( gca, 'position' );
                pos(1) = pos(1)+0.5*pos(3);
                axes('position',pos,'visible','off')
                colorbar
                caxis( cfg.zlim )

                str_subj = sprintf( '%i - RUN%i', subjs(s), r );
                str_freq = [ num2str( cfg.ylim(1) ) ' - ' num2str( cfg.ylim(2) ) 'Hz' ];

                axes('position',[0 0 1 1],'visible','off')
                tit = sprintf( '%s - %s - %s', str_subj, str_freq, group_names{g} );
                text( 0.5, 0.97, tit );

                set(gcf,'units','normalized','outerposition',[0 0 1 1],'PaperPositionMode', 'auto' )
                saveas( gcf, fullfile( dest_dir, [tit '.tif'] ), 'tif' )
            end
            
        end
        
    end
end