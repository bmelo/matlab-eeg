function [x desc x_desc x_mean_toi x_mean_toi_desc] = extract_freq( freq_data, freqs, toi , trialinfo, baseline )

t_inds = find(freq_data.time > toi(1) & freq_data.time < toi(2));

if nargin > 4 && ~isempty( baseline )
    baseline_inds = find(freq_data.time > baseline.toi(1) & freq_data.time < baseline.toi(2));
else
    baseline_inds = [];
end

x = [];
x_mean_toi = [];
x_desc = [];
x_mean_toi_desc = [];
desc = [];
desc_already_build = 0;

% every "trial" (subtrial free from artifact)
k=1;
while k < size(freq_data.powspctrm,1)
    
    % check if trialinfo matches when specified
    if exist( 'trialinfo', 'var' ) && ~isempty( trialinfo )
        % continue with next trial if this trial does not match
        if sum( trialinfo == freq_data.trialinfo(k) ) == 0
            k = k+1;
            continue
        end
    end
    
    %% find subtrials that are part of the same trial
    curr_trial = freq_data.trialinfo(k);
    
    % collect all subtrials that contain the same trial
    trial_k = k;
    trial_inds = [];
    while trial_k <= length(freq_data.trialinfo) && freq_data.trialinfo(trial_k) == curr_trial
        trial_inds = [trial_inds trial_k];
        trial_k = trial_k+1;
    end
    
    skip_trial = false ;
    
    %% find baseline per trial
    if ~isempty( baseline_inds )
        
        for f=1:size(freqs,1)
            
            f_inds = freq_data.freq >= freqs(f,1) & freq_data.freq <= freqs(f,2);
            
            x_base{f} = squeeze( nanmean( nanmean( nanmean( freq_data.powspctrm( trial_inds, : , f_inds, baseline_inds ), 3 ), 4 ), 1 ) );
            
            if isnan( x_base{f} )
                warning( 'no baseline data available. Skipping trial %i',  freq_data.trialinfo(trial_inds(end)) )
                skip_trial = true;
                break; % if no baseline exist do not use the trial
            end
        end
    end
    
    if ~skip_trial
        
        inds_mean = [];
        
        for t=1:length(t_inds)
            
            % check if there is valid for this time point
            if ~isnan( nanmean( freq_data.powspctrm(trial_inds,1,1,t_inds(t)), 1) )
                
                trial_x = [];
                for f=1:size(freqs,1)
                    
                    f_inds = freq_data.freq >= freqs(f,1) & freq_data.freq <= freqs(f,2);
                    
                    % mean over frequencies
                    x_chan = squeeze( mean( nanmean( freq_data.powspctrm( trial_inds, : , f_inds, t_inds(t) ), 1), 3 ) );
                    x_chan = reshape( x_chan, 1, numel( x_chan ) );
                    
                    
                    if ~isempty( baseline_inds )
                        x_chan = x_chan ./ x_base{f};
                    end
                    
                    trial_x = [trial_x x_chan];
                    
                    % make feature desciption
                    if ~desc_already_build
                        f_d = repmat({sprintf('F%ia%iHz',freqs(f,1), freqs(f,2))}, 1,length(x_chan));
                        freq_desc = strcat( freq_data.label', repmat({'_'},1,length(x_chan)) , f_d );
                        desc = [desc freq_desc];
                    end
                end
                
                desc_already_build = 1;
                
                % check again if there is no nan
                if sum(isnan(trial_x))== 0
                    x = [x; trial_x];
                    x_desc{end+1,1} = ['Stim_' num2str(freq_data.trialinfo(k)) '_Time_' num2str(freq_data.time( t_inds(t) ) )];
                    inds_mean = [inds_mean size(x,1)];
                end
            end
        end
        
        % just take mean over time points of a stimulus trial
        if ~isempty(x(inds_mean,:) )
            x_mean_toi = [x_mean_toi ; mean( x(inds_mean,:), 1 ) ];
            x_mean_toi_desc{end+1,1} = ['Stim_' num2str(freq_data.trialinfo(k)) '_Time_' num2str(freq_data.time( t_inds(1) ) ) '_to_' num2str(freq_data.time( t_inds(end) ) )];
        end
        
    end
    
    k = trial_inds(end)+1;
end

end
