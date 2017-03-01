% chan_cmb: N x 2 cell array of channel labels (if empty, all combinations
% will be used)
% freq_cmb: M x 2 cell array of feature combinations (if empty, only same
% frequency will be used)
function data_out = combinar_features( data, chan_cmb, freq_cmb, op )

data_out = data;
data_out.x = [];
data_out.features.desc = [];
data_out.features.type = [data.features.type op data.features.type];

if isempty( freq_cmb )
    
    % extract frequency description
    sepa = strfind( data.features.desc, '_' );
    for s=1:length(sepa)
       f_str{s} = data.features.desc{s}(sepa{s}+1:end); 
    end
    
    freq_desc = unique( f_str );
    freq_desc = reshape( freq_desc, numel(freq_desc), 1 );
    freq_cmb = [freq_desc freq_desc];
end

if isempty( chan_cmb )

    % extract channel description
    sepa = strfind( data.features.desc, '_' );
    for s=1:length(sepa)
       ch_str{s} = data.features.desc{s}(1:sepa{s}-1); 
    end
    
    channels = unique( ch_str );
    ind = 1;
    for ch=1:length(channels)
        for ch2=ch+1:length(channels)
            chan_cmb{ind,1} = channels{ch};
            chan_cmb{ind,2} = channels{ch2};
            ind=ind+1;
        end
    end
    
end

if isstr( chan_cmb )

    if strcmp( chan_cmb, 'left-right' )

        chan_cmb = [];
        
        % extract channel description
        sepa = strfind( data.features.desc, '_' );
        for s=1:length(sepa)
            ch_str{s} = data.features.desc{s}(1:sepa{s}-1);
        end
        
        left = [1 3 5 7 9];
        channels = unique( ch_str );
        ind = 1;
        for ch=1:length(channels)
           
            pos = channels{ch}(end:end);
            p = str2num( pos );
            
            if ~isempty( p )
                 if any( left == p )
                    
                     % found channel on left hemisphere
                     chan_cmb{ind,1} = channels{ch};
                     
                     % find channel correspondent on right hemisphere
                     right_ch = [channels{ch}(1:end-1) num2str(str2num(pos)+1)];
                     right_ch_ind = strcmp( channels, right_ch );
                     
                     chan_cmb{ind,2} = channels{right_ch_ind};
                     
                     ind=ind+1;
                     
                 end
            end
        end
        
    end
end

ind = 1;
for fc=1:size( freq_cmb )
    
    for cc = 1:size( chan_cmb )

        str_from = [ chan_cmb{cc,1} '_' freq_cmb{fc,1} ];
        str_to   = [ chan_cmb{cc,2} '_' freq_cmb{fc,2} ];
        
        from = find( strcmp( data.features.desc, str_from ) );
        to = find( strcmp( data.features.desc, str_to ) );
        
        if strcmp( op, '/' )
            data_out.x( :, ind ) = data.x(:,from) ./ data.x(:,to);
        elseif strcmp( op, '-' )
            data_out.x( :, ind ) = data.x(:,from) - data.x(:,to);
        elseif strcmp( op, '+' )
            data_out.x( :, ind ) = data.x(:,from) + data.x(:,to);
        elseif strcmp( op, '*' )
            data_out.x( :, ind ) = data.x(:,from) .* data.x(:,to);
        else
            error( 'Operation %s not defined', op )
        end
        
        data_out.features.desc{1,ind} = [str_from '_TO_' str_to];

        ind = ind+1;
    end
    
end
