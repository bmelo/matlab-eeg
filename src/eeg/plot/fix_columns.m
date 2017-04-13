function fix_columns( hAxes, duration )
%FIX_COLUMNS Summary of this function goes here
%   Detailed explanation goes here

%% Adjusting XAxes plots
for k = 1:length(hAxes)
    hLine = findobj(hAxes(k),'Type','line');
    x = get(hLine(1),'Xdata');

    xticks = [0 10 56 duration];
    
    set( hAxes(k), 'XTick', [0 lims(1) lims(2) length(signal)],...
        'XTickLabel', xticks, 'XLim', [min(x) max(x)]);
end

%% Putting same YLims
for k = 1:2:length(hAxes)
    ylim_equal( hAxes(k), hAxes(k+1) );
end

end

