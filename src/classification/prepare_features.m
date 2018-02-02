function [ out ] = prepare_features( data, random )
%PREPARE_FEATURES Summary of this function goes here
%   Detailed explanation goes here

len = get_min_length( data );

%% Features
out.features = [data(1).N(:, 1:len) data(1).T(:, 1:len) data(1).A(:, 1:len)];
for nF = 2:length(data)
    out.features = vertcat( out.features, [data(nF).N(:, 1:len) data(nF).T(:, 1:len) data(nF).A(:, 1:len)]);
end
% removing NaN values
lines_notNaN = ~any(isnan(out.features),2);
out.features = out.features( lines_notNaN,:);

%% Classes
out.classes = zeros(3, size(out.features,2));
numN = len;
numT = len;
numA = len;

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
% Very specialized for a case
% Must be rewritten for use in other projects
n_samples = size(out.classes, 2);
n_blocks = 16;
lenN = ceil( numN / (16 * 2) );
lenT = ceil( numT / 16 );
lenA = ceil( numA / 16 );
excessive = 0;
jump = mod( 16 - mod(numN, 16), 16 );
for nB=1:n_blocks    
    firstNT = (nB-1) * lenN + 1;
    firstNA = (nB-1) * lenN + 1 + ceil(numN/2);
    firstT  = jump + numN + (nB-1) * lenT + 1;
    firstA  = jump + numN + numA + (nB-1) * lenA + 1;
    
    if nB == n_blocks
        excessive = jump;
    end
    
    idxB = [
        firstNT : (firstNT + lenN -1) ...
        firstNA : (firstNA + lenN -1) ...
        firstT  : (firstT  + lenT -1) - excessive ...
        firstA  : (firstA  + lenA -1) - excessive ...
        ];
    
    % Removing excessive indexes
    idxB(idxB > n_samples ) = [];
    out.block(idxB) = nB;
end

end

function min_len = get_min_length(data)

min_len = Inf;
for k=1:length(data)
    min_len = min( [min_len size(data(k).N, 2)] );
end

end