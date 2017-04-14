function fix_columns( hAxes, duration )
%FIX_COLUMNS Summary of this function goes here
%   Detailed explanation goes here

%% Putting same YLims
for k = 1:2:length(hAxes)
    ylim_equal( hAxes(k), hAxes(k+1) );
end

%% Adjusting XAxes plots
for k = 1:length(hAxes)
    xlims = axes_lims(hAxes(k));
    set( hAxes(k), 'XLim', xlims);
    
    %% XTicks in seconds
    % Delimiters
    if exist('duration', 'var')
        vlines = findobj(hAxes(k),'Tag','vline');
        if isempty(vlines)
            break
        end
        % Fixes YLim
        ylims = get(hAxes(k),'YLim');
        for nL = 1:length(vlines)
            v_data(nL) = max( get(vlines(nL), 'XData') );
            set(vlines(nL), 'YData', ylims);
        end
        v_data = sort(v_data);
        v_data_s = round( v_data/xlims(2)*duration );
        
        xticks = [0 v_data_s duration];
        set( hAxes(k), 'XTick', [0 v_data xlims(2)], 'XTickLabel', xticks);
    end
end

end