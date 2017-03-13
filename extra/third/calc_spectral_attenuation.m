% freqs: Nx2 frequency ranges where the attenuation should be calculated
% out: the attenuation i.e. the mean attenuation over the specified N
% frequency ranges for each channel
function out = calc_spectral_attenuation( EEG1, EEG2, freqs )

if size(EEG1.data,1) ~= size(EEG2.data,1)
    error( 'cannot compare EEG with different channel sizes' )
end

for ch=1:size(EEG1.data,1)
    
    for k=1:size(freqs,1)
        
        inds = EEG1.data_freq_freqs > freqs(k,1) & EEG1.data_freq_freqs < freqs(k,2);
        % mean over trials
        m1(k) = mean( mean( EEG1.data_freq( ch, inds, :), 3 ), 2 );
        m2(k) = mean( mean( EEG2.data_freq( ch, inds, :), 3 ), 2 );
        
        if ~isfield( EEG1, 'data_freq_std')
            std1(k) = mean( std( EEG1.data_freq( ch, inds, :), 3 ), 2 );
            std2(k) = mean( std( EEG2.data_freq( ch, inds, :), 3 ), 2 );
        else
            std1(k) = mean( EEG1.data_freq_std( ch, inds, :), 2 );
            std2(k) = mean( EEG2.data_freq_std( ch, inds, :), 2 );
        end
        
    end
    
    out.att(ch) = mean(m1./m2);
    out.std1(ch) = mean(std1);
    out.std2(ch) = mean(std2);

end
end