function plot_sync_desync(epochs)

cond = 'TASK_T';
nData = 23000; % 46s
filterB = 1;

%bpFilt = designfilt('bandpassfir','FilterOrder',2, ...
%         'CutoffFrequency1',7,'CutoffFrequency2',45, ...
%         'SampleRate',500/2);

%[B,A,C,D] = butter(2,[7 30]/(500/2));

% Plotting signals
figure;
subplot(2, 1, 1);
title([cond ' F_5']);
data = zeros( length(epochs.(cond)), nData );
for n=1:length(epochs.(cond))
    hold on;
    data(n,:) = epochs.(cond)(n).data(46,1:nData);
    if filterB
        [b,a] = butter(4,[7 30]/(500/2));
        data(n,:) = filtfilt(b,a, data(n,:));
    end
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