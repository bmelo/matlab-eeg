function [ matrices ] = matrices( epochs, varargin )
%MATRICES Summary of this function goes here
%   Detailed explanation goes here

only_before = utils.Var.arg_exist(varargin, 'before');
% Each condition
for field = fields(epochs)'
    cond = field{1};
    
    %% Preparing sync/desync
    n_pieces = length(epochs.(cond));
    
    if only_before
        data = [epochs.(cond)(:).before epochs.(cond)(:).data];
    else
        data = [epochs.(cond)(:).before epochs.(cond)(:).data epochs.(cond)(:).after];
    end
    [n_ch, len] = size(data);
    
    data = reshape( data, n_ch, len/n_pieces, n_pieces );
    
    matrices.(cond) = data;
    
end

end

