function [ matrices ] = matrices( epochs )
%MATRICES Summary of this function goes here
%   Detailed explanation goes here

% Each condition
for field = fields(epochs)'
    cond = field{1};
    
    %% Preparing sync/desync
    n_pieces = length(epochs.(cond));
    
    data = [epochs.(cond)(:).before epochs.(cond)(:).data epochs.(cond)(:).after];
    [n_ch, len] = size(data);
    
    data = reshape( data, n_ch, len/n_pieces, n_pieces );
    
    matrices.(cond) = data;
    
end

end

