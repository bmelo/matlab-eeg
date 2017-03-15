function [ matrices ] = matrices( epochs, varargin )
%MATRICES Summary of this function goes here
%   Detailed explanation goes here

only_before = utils.Var.arg_exist(varargin, 'before');
% Each condition
for field = fields(epochs)'
    cond = field{1};
    
    %% Preparing matrix with all elements
    % calculating basic info
    n_pieces = length(epochs.(cond));
    [n_ch, len_data] = size(epochs.(cond)(1).data);
    len_before = length(epochs.(cond)(1).before);
    len_after = length(epochs.(cond)(1).after);
    
    len_total = len_data + len_before;
    if ~only_before
        len_total = len_total + len_after;
    end
    
    % merging data
    data = zeros(n_ch, n_pieces, len_total);
    for nP = 1:n_pieces
        if only_before
            data(:,nP,:) = [epochs.(cond)(nP).before epochs.(cond)(nP).data];
        else
            data(:,nP,:) = [epochs.(cond)(nP).before epochs.(cond)(nP).data epochs.(cond)(nP).after];
        end
    end
    
    matrices.(cond) = data;
    
end

end

