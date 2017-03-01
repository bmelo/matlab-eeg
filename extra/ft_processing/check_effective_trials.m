nan_inds = isnan( freq.powspctrm );

effective_trials = zeros(1,size(freq.powspctrm,4));

for t=1:size( nan_inds, 4)
    
    for trials = 1:size( nan_inds, 1)
        
        % verify if for any existing nan for a given trial and time, all
        % frequencies and channels are nan
        % this is true
%         if nan_inds(trials,1,1,t)
%             sum( sum( nan_inds( trials,:,:,t ) ) ) == numel( nan_inds( trials,:,:,t ) )
%         else
%             sum( sum( nan_inds( trials,:,:,t ) ) ) == 0
%         end
        
        if nan_inds( trials, 1, 1, t ) == 0
            effective_trials(t) = effective_trials(t) + 1;
        end
        
    end
end

