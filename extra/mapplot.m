figure;
limits = [min(medians) max(medians)];
topoplot(medians, chanlocs, 'maplimits', limits); 
cbar('vert',1, limits);