function [ EEG_out ] = filter_gradient_artefacts( EEG, janela )

EEG_out = EEG;
totalV = size(EEG_out.data,3);
tamParte = janela/2;
for ch=1:size(EEG.data,1)
  
    one_chan = squeeze( EEG.data(ch,:,:) );
    
    % tirar média para cada janela
    baseline_janela = mean( one_chan, 1 );
    
    one_chan_demeaned = one_chan - repmat( baseline_janela, size( one_chan,1), 1);
    
    
    %Faz o janelamento, removendo a media do sinal central
    for vol=1:totalV
        
        if janela + 1 >= totalV
            inds = 1:totalV;
        else
            %Indices usados para calcular a media
            if vol <= tamParte
                inds = 1:janela+1;
            elseif totalV-vol <= tamParte
                inds = totalV-janela-1:totalV;
            else
                inds = (vol-tamParte):vol+tamParte;
            end
        end
        
        inds( inds == vol ) = [];
        
        % calcular média sobre as janelas 
        m = mean( one_chan_demeaned(:, inds), 2 );
        
        EEG_out.data(ch,:,vol) = EEG_out.data(ch,:,vol) - m';
        
    end
  
end


end