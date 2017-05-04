function [ matrices ] = matrices( epochs, varargin )
%MATRICES Summary of this function goes here
%   Detailed explanation goes here

if isfield(epochs, 'ext')
    epochs = epochs.ext.epochs;
end

% Each condition
for field = fields(epochs)'
    cond = field{1};
    
    %% Preparing matrix with all elements
    % calculating basic info
    n_pieces = length(epochs.(cond));
    [n_ch, len_data] = size(epochs.(cond)(1).data);
    
    % merging data
    data = zeros(n_ch, n_pieces, len_data);
    for nP = 1:n_pieces
        data(:,nP,:) = epochs.(cond)(nP).data;
    end
    
    matrices.(cond) = data;    
end

end

