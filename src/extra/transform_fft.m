function EEG = transform_fft( EEG, stats_only )

for ch=1:size(EEG.data,1)
    
    for tr=1:size(EEG.data,3)
        
        % usar trial completo
        win       = hann( size(EEG.data,2) );
        overlap   = 0;
        srate     = EEG.srate;
        nfft      = 2^nextpow2( size(EEG.data,2) );
        
        [spec,freqs] = pwelch(EEG.data(ch,:,tr), win, overlap, nfft,srate);
       
        EEG.data_freq(ch,:,tr) = spec;
        EEG.data_freq_freqs    = freqs;
        
    end
    
    EEG.data_freq_mean(ch,:,1) = mean( EEG.data_freq(ch,:,:), 3 );
    EEG.data_freq_std(ch,:,1) = std( EEG.data_freq(ch,:,:), 0, 3 );
   
end

if stats_only
    EEG.data_freq = [];
end
    
