%init_fieldtrip

data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT';

subjs = [3 11 13 16 17 19];

freqs = [1 4; 4 8; 8 13; 8 10; 10 13; 13 30; 17.5 18.5];
freq_names = { 'delta', 'theta', 'alpha', 'low_alpha', 'high_alpha', 'beta', '18' };

chans = { 'Fp1', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'T7', 'C3', 'Cz', 'C4', 'T8', 'P7', 'P3', 'Pz', 'P4', 'P8', 'O1', 'O2' };

ind = 1;
% loop over subjects
for s=1:length(subjs)
    
    % loop over runs
    for r=1:2
        
        
        for b = 1:length(freqs)
            
            band_data_dir = fullfile( data_dir, freq_names{b} );
            
            fname = sprintf( '%s_tc_SUBJ%03i_RUN%i_Reref_Avg_ALL.mat', freq_names{b}, subjs(s), r ) ;
            
            load( fullfile( band_data_dir, fname ) );
            
            data.inst_phase_chans = chans;
            
            clear chan_ind;
            
            for ch = 1:length(chans)
                chan_ind(ch) = find( strcmp( chans{ch}, data.label ) );
                if isempty( chan_ind(ch) ), error( 'Channel %s not found', chans{ch} ), end;
            end
            
            for tr=1:length(data.trial)
                
                data.phase_diff{tr} = []; % empty to clean already calculated stuff
                
                % calculate instantaneous phase for each channel
                data.inst_phase{tr} = atan( imag( hilbert(data.trial{tr}(chan_ind,:) ) ) ./ data.trial{tr}(chan_ind,:) );
                
                % loop over channel pairs
                for chA = 1:length(chans) - 1
                    for chB = chA+1:length(chans)
                        
                        angleA = data.inst_phase{tr}(chA,:);
                        angleB = data.inst_phase{tr}(chB,:);
                        
                        data.phase_diff{tr}(chA,chB,:) = mod( (angleA - angleB), 2*pi );
                                                
                    end
                end
            end
            
            save( fullfile( band_data_dir, fname ), 'data');
            fprintf( '% saved at %s\n', fname, datestr( now ) )
            
        end
    end
    
end