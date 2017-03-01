data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\TimeFreqData';
log_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\data_analysis_logfiles\ana_RM\logs';

subjs = [3 11 13 16 17 19];
% subjs = [3];

elecs = { 'C1' };
foi = [4 8; 8 13; 13 20];
toi = [5 12];

SUBJ = [];
FFT  = [];

% loop over subjects
for s=1:length(subjs)
    
    % loop over runs
    for r=1:2

        file2 = sprintf('Samba_EEGRMf_VP_%i_%i.txt',subjs(s), r);
        [Vp2 trial2	 stim2 rat_synch RTsync] = textread(fullfile(log_dir,file2),'%s %s %s %f %f','headerlines',1);
        
        fname = sprintf( 'tf_tc_SUBJ%03i_RUN%i_Reref_Avg_ALL.mat', subjs(s), r ) ;

        load( fullfile( data_dir, fname ) );
   
        for ch=1:length(elecs)
            
            %% identificar trials corretos e extrair toi do trial correto
            freq.cfg.previous.trlold
            
        
            %% 
            
        end
        
    end
    
end