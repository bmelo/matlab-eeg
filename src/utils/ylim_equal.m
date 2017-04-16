function ylim_equal( varargin )
%YLIM_EQUAL Summary of this function goes here
%   Detailed explanation goes here

param = 'YLim';
if strcmp(varargin{end}, 'data')
    param = 'YData';
end

all_v = [];
for nA = 1:length(varargin)
    hgca = varargin{nA};
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
    set(varargin{nA}, 'YLim', [ min(all_v) max(all_v) ]);
end

end

