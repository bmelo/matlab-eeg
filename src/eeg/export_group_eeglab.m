function export_group_eeglab( group, lims, prefix_export )
%EXPORT_GROUP_EEGLAB Summary of this function goes here
%   Detailed explanation goes here

conds = fields(group.mean);

% Defining parameters
p.channels = {group.channels};
p.srate = group.srate;
p.data = [];

for nC = 1:length(conds)
    cond = conds{nC};
    p.data = group.mean.(cond);
    
    % Filtering data, if necessary
    if ~isempty( lims )
        lims = floor( lims * p.srate );
        p.data = p.data(:, lims(1):lims(2));
    end
    
    % Exporting
    export_eeglab( p, [prefix_export '_' cond] );
end

end

