function [ matrices ] = matrices( epochs )
%MATRICES Summary of this function goes here
%   Detailed explanation goes here

% Each condition
for field = fields(epochs)'
    cond = field{1};
    
    %% Preparing sync/desync
    n_pieces = length(epochs.(cond));
    [n_ch, len] = size(epochs.(cond)(1).data);
    data = [epochs.(cond)(:).data];
    data = reshape( data, n_ch, len, n_pieces );
    
    matrices.(cond) = data;
    
end

end

