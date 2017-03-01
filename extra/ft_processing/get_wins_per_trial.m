function wins_per_trial = get_wins_per_trial( trial_desc, wins_desc )


for t=1:length(trial_desc)
   
    for w=1:length(wins_desc)
        
        if ~strcmp( trial_desc{t}(1:7), wins_desc{w}(1:7) )
            break;
        end
            
    end
    
    wins_per_trial( t ) = w-1;
    
    wins_desc(1:w-1) = [];
    
end

% add 1 to the last one 
wins_per_trial( end ) = wins_per_trial( end ) + 1;

end