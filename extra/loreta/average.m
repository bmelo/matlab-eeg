function [ avgs ] = average( data, model, fh )
%AVERAGE Summary of this function goes here
%   Detailed explanation goes here
if nargin<3, fh = @mean; end

numCols = size(data, 2);
nR = 1;

% Extract begins of each condition
for k = 2:length(model)
    if model(k-1)==0 && model(k)==1
        first = k+10*250+1;
        last  = k+36*250;
        
        % Extracting averages
        for nC = 1:numCols
            avgs(nR, nC) = fh( data(first:last,nC) );
        end
        
        nR = nR+1;
    end
end

end

