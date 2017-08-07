function [ out ] = prepare_features( data, random )
%PREPARE_FEATURES Summary of this function goes here
%   Detailed explanation goes here

%% Features
out.features = [data(1).N data(1).T data(1).A];
for nF = 2:length(data)
    out.features = vertcat( out.features, [data(nF).N data(nF).T data(nF).A]);
end
% removing NaN values
lines_notNaN = ~any(isnan(out.features),2);
out.features = out.features( lines_notNaN,:);

%% Classes
out.classes = zeros(3, size(out.features,2));
numN = size(data(1).N, 2);
numT = size(data(1).T, 2);
numA = size(data(1).A, 2);

% Random class, to see chance result
if random
   for rK = 1:3:length(out.classes)
       randP = randperm(3);
       out.classes( randP(1), rK ) = 1;
       out.classes( randP(2), rK+1 ) = 1;
       out.classes( randP(3), rK+2 ) = 1;
   end
else
    out.classes(1, 1:numN) = 1;
    out.classes(2, numN+1:numN+numT) = 1;
    out.classes(3, end-numA+1:end) = 1;
end

%% Blocks
n_blocks = 16;
lenN = numN / (16 * 2);
lenT = numT / 16;
lenA = numA / 16;
for nB=1:n_blocks
    firstNT = (nB-1) * lenN + 1;
    firstNA = (nB-1) * lenN + 1 + numN/2;
    firstT = numN + (nB-1) * lenT + 1;
    firstA = numN + numA + (nB-1) * lenT + 1;
    idxB = [
        firstNT : (firstNT + lenN -1) ...
        firstNA : (firstNA + lenN -1) ...
        firstT  : (firstT  + lenT -1) ...
        firstA  : (firstA  + lenA -1) ...
        ];
    out.block(idxB) = nB;
end

end

