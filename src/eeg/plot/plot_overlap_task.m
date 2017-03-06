function [ output_args ] = plot_overlap_task( epochs )
%PLOT_OVERLAP_TASK Summary of this function goes here
%   Detailed explanation goes here

% Plotting signals
figure;
subplot(2, 1, 1);
title([cond ' F_5']);
data = zeros( length(epochs.(cond)), nData );
for n=1:length(epochs.(cond))
    hold on;
    data(n,:) = epochs.(cond)(n).data(46,1:nData);
    % Sinc/Dessinc
    data(n,:) = data(n,:).^2;
    plot( data(n,:) );
end
ampA = (max(max(data)) - min(min(data))) / 2;
% Sinc/Dessinc
%sMean = sqrt(mean(data));
sMean = mean(data);
ampM = (max(sMean)-min(sMean))/2;
meanM = mean(sMean);

interv = 0:pi/3833:6*pi;
plot( 1:length(interv), (sin(interv)*ampA+meanM), 'b', 'LineWidth', 3 )
hold off;

% Plotting mean
subplot(2, 1, 2);
plot(1:length(sMean), sMean);
hold on;
title([cond 'F_5 mean']);
plot( 1:length(interv), (sin(interv)*ampM+meanM), 'b', 'LineWidth', 3 )
hold off;

end

