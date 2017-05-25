function [ out ] = prepare_features( data )
%PREPARE_FEATURES Summary of this function goes here
%   Detailed explanation goes here

%% Features
out.features = [data(1).N data(1).T data(1).A];
for nF = 2:length(data)
    out.features = vertcat( out.features, [data(nF).N data(nF).T data(nF).A]);
end

%% Classes
out.classes = zeros(3, size(out.features,2));
numN = size(data(1).N, 2);
numT = size(data(1).T, 2);
numA = size(data(1).A, 2);

out.classes(1, 1:numN) = 1;
out.classes(2, numN+1:numN+numT) = 1;
out.classes(3, end-numA+1:end) = 1;

end

