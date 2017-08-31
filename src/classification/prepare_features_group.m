function [ out ] = prepare_features_group( data, n_subjs )
%PREPARE_FEATURES_GROUP Summary of this function goes here
%   Detailed explanation goes here

%% Features
n_feats = length(data) / n_subjs;
out.features = [];
out.classes  = [];
out.nsubj    = [];

for nS = 1:n_subjs
    %% Preparing inputs for each subject
    first = (nS-1)*n_feats + 1;
    s_features = [];
    for nF = first : first + n_feats - 1
        s_features = vertcat( s_features, [data(nF).N data(nF).T data(nF).A]);
    end
    
    out.features = [out.features s_features];
    n_points = size(s_features,2);
    
    %% Classes
    s_classes = zeros(3, n_points);
    numN = size(data(1).N, 2);
    numT = size(data(1).T, 2);
    numA = size(data(1).A, 2);
    
    s_classes(1, 1:numN) = 1;
    s_classes(2, numN+1:numN+numT) = 1;
    s_classes(3, end-numA+1:end) = 1;
    out.classes = [out.classes s_classes];
    
    %% Subjects    
    out.nsubj(end+1:end+n_points) = nS;
end

end

