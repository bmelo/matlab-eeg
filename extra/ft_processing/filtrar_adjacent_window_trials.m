function data = filtrar_adjacent_window_trials( data )

k=1;
while k < length(data.x_desc)-1
   
    pre = data.x_desc{k};
    suc = data.x_desc{k+1};
    
    a = strfind( pre, '_' );
    pre_time = str2num( pre( a(end)+1 : end ) );

    a = strfind( suc, '_' );
    suc_time = str2num( suc( a(end)+1 : end ) );

    if suc_time == pre_time + 1 && strcmp( pre(1:7), suc(1:7) )
        data.x_desc(k+1) = [];
        data.y(k+1)      = [];
        data.x(k+1,:)    = [];
    else
        k = k+1;
    end
    
end

end