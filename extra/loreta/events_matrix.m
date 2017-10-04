function [events, labels] = events_matrix( srate )

labels = {'N' 'T' 'A'};
conds = {'T' 'A'};
n = 1;
last = 0;
events = zeros(1, 61*32*srate);
for run=1:4
    for cond = 1:2
        for trials = 1:4
            label = conds{cond};
            
            events( last+1:last+(10*srate) ) = 1;
            events( last + (10*srate) + 1 : last+(56*srate) ) = find(strcmp({'N' 'T' 'A'}, label));
            events( last + (56*srate) + 1 : last+(61*srate) ) = 1;
            
            last = last + (61 * srate);
        end
    end
end

end