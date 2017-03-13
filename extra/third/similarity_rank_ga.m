function [similarity_matrix similarity_matrix_mean volume_correlation_mean] = similarity_rank_ga( EEG )

for ch=1:size(EEG.data,1)
   
    % excluir ultimo volume que nao tem o dynamic stabilization
    one_chan = squeeze( EEG.data(ch,:,1:end-1) );
    
    similarity_matrix(ch,:,:) = corrcoef( one_chan );
        
end

similarity_matrix_mean = squeeze( mean( similarity_matrix, 1) );

volume_correlation_mean = mean( similarity_matrix_mean, 1);

end