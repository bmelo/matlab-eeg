function data = filtrar_features( data, chan_filtro, freq_filtro )

ind_features_chan = zeros(1, length( data.features.desc ) );
ind_features_freq = zeros(1, length( data.features.desc ) );

if ~isempty( chan_filtro )
    for k=1:length(chan_filtro)
        
        for feat=1:length( data.features.desc )
            if strfind( data.features.desc{feat}, chan_filtro{k} ) == 1 % tem que corresponder desde o incicio do label (para evitar problemas com canais como Pz e CPz que sao substrings
                ind_features_chan(feat) = 1;
            end
        end
    end
else
    ind_features_chan = 1;
end

% 
if ~isempty(freq_filtro)
    
    for k=1:length(freq_filtro)
        
        for feat=1:length( data.features.desc )
            if ~isempty( strfind( data.features.desc{feat}, freq_filtro{k} ) )
                ind_features_freq(feat) = 1;
            end
        end
    end
else
   ind_features_freq = 1; 
end

ind_features = ind_features_freq & ind_features_chan ;

data.x( :, ~ind_features ) = [];
data.features.desc( ~ind_features ) = [];