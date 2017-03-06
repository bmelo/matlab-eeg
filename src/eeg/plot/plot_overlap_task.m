function plot_overlap_task( epochs )
%PLOT_OVERLAP_TASK Summary of this function goes here
%   Detailed explanation goes here

epochsM = matrices(epochs);
plot_channel( epochsM, 46, 'F_5')

end


%% Plot each channel
function plot_channel( epochs, n_ch, chan_name )
import utils.plot.lines.vline;
figure;

conds = {'NEUTRAL' 'TASK_T' 'TASK_A'};
colors = {'k' 'm' 'b'};
first = 1;
for nC = 1:length(conds)
    cond = conds{nC};
    
    last = first-1 + length( epochs.(cond) );
    x_pos = first:last;
    
    plot_cond( epochs.(cond), cond, n_ch, chan_name, x_pos);
    
    first = last + 1;
end

% Adjusting plots
first = 1;
for nC = 1:length(conds)
    cond = conds{nC};
    color = colors{nC};
    for nP = 1:2
        subplot(2, 1, nP);    
        hold on;
        xlim([1,max(x_pos)]);
        vline(first, color, cond);
        hold off;
    end
    first = first + length( epochs.(cond) );
end

end


%% Plot Conditions
function plot_cond( signal, cond, n_ch, chan_name, x_pos )
% Plotting signals of one channel
subplot(2, 1, 1);
title( sprintf('%s %s', cond, chan_name) );

data = squeeze( signal(n_ch,:,:) );

% Some important info
ampA = (max( data(:) ) - min( data(:) )) / 2;
sMean = mean(data, 2);
ampM = (max(sMean)-min(sMean))/2;
meanM = mean(sMean);

% Plotting each piece
hold on;
plot( x_pos, data );
if strfind(cond, 'TASK')
    interv = 0 : (6*pi/(length(x_pos)-1)) : 6*pi;
    plot( x_pos, (sin(interv)*ampA+meanM), '--k', 'LineWidth', .5 )
end
hold off;

% Plotting mean
subplot(2, 1, 2);
hold on;
plot(x_pos, sMean);
title([cond 'F_5 mean']);
if exist('interv', 'var')
    plot( x_pos, (sin(interv)*ampM+meanM), '--k', 'LineWidth', .5 )
end
hold off;

end