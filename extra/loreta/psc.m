function [ avgs ] = psc( data, model )
%PSC Summary of this function goes here
%   Detailed explanation goes here

srate = 250;
numCols = size(data, 2);
nR = 1;

% Extract begins of each condition
for k = 2:length(model)
    if model(k-1)==0 && model(k)==1
        first = k+10*srate;
        last  = k+36*srate-1;
        neutral = (k-5*srate) : (k-1);
        
        % Extracting averages
        for nC = 1:numCols
            % Extracting baseline to compute PSC
            baseline = median( data(neutral, nC) );
            
            psc_data = ( data(first:last,nC) - baseline ) / baseline;
            %avgs(nR, nC) = median( psc_data(1:13*srate) );
            %nR = nR + 1;
            %avgs(nR, nC) = median( psc_data(13*srate+1:end) );
            avgs(nR, nC) = median( psc_data );
        end
        
        nR = nR+1;
    end
end

end

