function plot_task( signal, lims, mult )
%PLOT_TASK Summary of this function goes here
%   Detailed explanation goes here

import utils.plot.lines.vline;

% Plotting signals of one channel
data = squeeze( signal );

% Plotting each piece
hold on;
plot( data );

% Putting lines
vline(lims(1), '--g', 'start');
if length(lims) == 2
    vline(lims(2), '--r', 'end');
end

% % Plotting experimental design
% ampA = (max( data(:) ) - min( data(:) )) / 2;

% task_x = lims(1):lims(2);
% interv = linspace(-pi/2, 5.5*pi, length(task_x));
% interv = -pi/2 : (6*pi/(length(task_x)-1)) : (6*pi - pi/2);
% plot( task_x, mult* ( sin(interv)*ampA+(ampA/2) ), '--k', 'LineWidth', .5 )

hold off;
end

