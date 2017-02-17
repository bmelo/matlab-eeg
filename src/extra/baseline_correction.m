function [EEG_out] = baseline_correction( EEG, option )

EEG_out = EEG;

for ch=1:size(EEG.data,1)
   
    % excluir ultimo volume que nao tem o dynamic stabilization
    one_chan = squeeze( EEG.data(ch,:,:) );

    if strcmpi( option, 'mean' )
        m = mean( one_chan );
    elseif strcmpi( option, 'range' )
        m = ( max( one_chan ) - min(one_chan) ) / 2;
    elseif strcmpi( option, 'median' )
        m = median( one_chan );
    elseif strcmpi( option, 'max' )
        m = [0 diff( max( one_chan ) )];
    elseif strcmpi( option, 'min' )
        m = [ 0 diff(min( one_chan ) )];
    end
    
    EEG_out.data(ch,:,:) = one_chan - repmat( m, size(one_chan,1), 1);
            
end

end