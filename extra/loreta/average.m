function [ avgs ] = average( data, model )
%AVERAGE Summary of this function goes here
%   Detailed explanation goes here

numCols = size(data, 2);

% Extract begins of each condition
idxs = [];
for k = 2:length(model)
    if model(k-1)==0 && model(k)==1
        first = k+10*250+1;
        last  = k+36*250;
        idxs  = [idxs first:last];
    end
end

% Calculating correlation
for nC = 1:numCols    
    avgs(nC) = median( data(idxs,nC) );
end

end

