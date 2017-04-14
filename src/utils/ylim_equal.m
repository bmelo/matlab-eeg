function ylim_equal( gca1, gca2 )
%YLIM_EQUAL Summary of this function goes here
%   Detailed explanation goes here

ylim1 = axes_lims(gca1, 'YData');
ylim2 = axes_lims(gca2, 'YData');
all_v = [ylim1 ylim2];

ylims = [ min(all_v) max(all_v) ];

set(gca1, 'YLim', ylims);
set(gca2, 'YLim', ylims);

end

