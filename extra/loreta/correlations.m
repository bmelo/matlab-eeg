% Computes correlations between model and temporal series for each ROI
function [corrs p] = correlations( data, model, normparam, filterSignal )  

if nargin < 3, normparam = false; end
if nargin < 4, filterSignal = false; end

numCols = size(data, 2);

corrs = zeros(1, numCols);
p = corrs;

% Calculating correlation
for nC = 1:numCols
    % Normalizing model to the same space signal
    % don't influence results, but help in plots
    if ~normparam
        dataN = data(:,nC)';
    else
        dataN = data(:,nC)/norm(data(:,nC), Inf);
        dataN = dataN';
    end
    
    % Filtering signal
    dataFN = filterBin(dataN);
    
    % Doing correlation
    if filterSignal
        dataN = dataFN;
    end
    [corrs(nC) p(nC)] = corr( dataN', model' );
end

end

function outData = filterBin( data )
% Filtering signal
h = [1/2 1/2];
binomialCoeff = conv(h,h);
for n = 1:4
    binomialCoeff = conv(binomialCoeff,h);
end
outData = filter(binomialCoeff, 1, data)';
end

function outData = filterSG( data )
% Filtering signal
outData = sgolayfilt(data, 8, 501)';
end
