function ylim_equal( fhandles, param )
%YLIM_EQUAL Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2, param = 'YLim'; end

if strcmp(param, 'data')
    param = 'YData';
end

all_v = [];
for nA = 1:length(fhandles)
    hgca = fhandles(nA);
    if ischar(hgca)
        break;
    end
    
    % Check if extracts YData or YLim
    if strcmp(param, 'YData')
        ylims = axes_lims_std(hgca);
    else
        ylims = get(hgca, param);
    end
    all_v = [all_v ylims];
end

% Chaging YLim with default values
for nA = 1:(length(all_v)/2)
    set(fhandles(nA), 'YLim', [ min(all_v) max(all_v) ]);
end

end

