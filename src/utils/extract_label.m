function [ label ] = extract_label( filename, band )
%EXTRACT_LABEL Summary of this function goes here
%   Detailed explanation goes here

% When using filename
if nargin < 2
    parts = regexp(filename, '_', 'split', 'once');
    label = strrep(parts{2}, '_', '-');
else
    % Using prefix and bandwidth
    switch(filename)
        case '', featName='';
        case 'p', featName='power';
        case 'sync', featName='ERD/ERS';
        case 'dens', featName='Spectral Density';
        otherwise, featName='feat ?';
    end
    label = sprintf('%s [%d-%d]', featName, band);
end

end

