function inds = match_trials( desc, category )

    k = 1;
    for d=1:length(desc)
        
        desc_cat = desc2cat( desc{d} ) ;
        
        % fprintf( 'd: %i\n', d );
        
        for c=k:length(category)
        
            % fprintf( '\tc: %i\n', c );
        
            if category(c) == desc_cat
                
                inds(d) = c;
                break;
            else 
                fprintf( '%i. Trial (Cat: %i) missing\n', c, category(c) );
            end
            
        end
        
        k = c+1;
            
    end

end

function ret = desc2cat( desc )

    desc_cat = str2num( desc(6:7) );

    ret = -1;
    
    if desc_cat == 10 || desc_cat == 20 || desc_cat == 30 
        ret = 0;
    elseif desc_cat == 11 || desc_cat == 21 || desc_cat == 31 
        ret = 28;
    elseif desc_cat == 12 || desc_cat == 22 || desc_cat == 32 
        ret = 55;
    elseif desc_cat == 13 || desc_cat == 23 || desc_cat == 33 
        ret = 83;
    else
        error( 'could not extract category of trial')
        
    end
end