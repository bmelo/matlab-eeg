function [ lims ] = axes_lims_std( h_axe )
%AXES_LIMS Summary of this function goes here
%   Detailed explanation goes here

param = 'YData';

%% Adjusting XAxes plots
h_lines = findobj(h_axe,'Type','line', 'Tag', '');
lims = get(h_axe, 'YLim');
vals = [];
for k = 1:length(h_lines)
    vals = [vals get(h_lines(k), param)];
end
v_mean = mean(vals);
v_std = std(vals);
margin = v_std*3;
v_lims = [v_mean-margin v_mean+margin];

lims = [ max([lims(1) v_lims(1)]) min([lims(2) v_lims(2)])];
end

