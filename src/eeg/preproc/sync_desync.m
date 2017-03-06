function sdEpochs = sync_desync(epochs)
% SYNC_DESYNC 
% Details

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


end