function [ lims ] = axes_lims( h_axe, direction )
%AXES_LIMS Summary of this function goes here
%   Detailed explanation goes here

if nargin == 1, direction = 'XData'; end

%% Adjusting XAxes plots
h_lines = findobj(h_axe,'Type','line', 'Tag', '');
v_min = 1;
v_max = v_min;
for k = 1:length(h_lines)
    x = get(h_lines(k),direction);
    v_min = min([v_min min(x)]);
    v_max = max([v_max max(x)]);
end

lims = [v_min v_max];
end

