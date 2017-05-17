function fix_columns( hAxes, duration )
%FIX_COLUMNS Summary of this function goes here
%   Detailed explanation goes here

%% Putting same YLims
for k = 1:2:length(hAxes)
    ylim_equal( [hAxes(k) hAxes(k+1)], 'data');
end

%% Adjusting XAxes plots
adjust_x_time( hAxes, duration );

end