figure

for k=1:size( freq_data.powspctrm )
    
    imagesc( squeeze( freq_data.powspctrm(k, 5, :, : ) ) );
    title( freq_data.trialinfo( k ) )
    
    pause
    
end

