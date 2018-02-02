function [ events ] = clear_bad_events( events )
%CLEAR_BAD_EVENTS Treating problems in some subjects data
%   Detailed explanation goes here
remove = [];
for k=1:length(events)
    if strcmp(events(k).type, 'S  3')
        if (events(k+1).latency - events(k).latency) < 10 || ...
           (events(k).latency   - events(k-1).latency) < 10
            remove = [remove k];
        end
    end
end
events(remove) = [];
end
