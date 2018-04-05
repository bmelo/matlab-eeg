function [ EEG ] = laplacian_filter( EEG, neighs )
%LAPLACIAN_FILTER Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2, neighs = 8; end

load('extra/channels_location');

% Reading data
EEG.chanlocs = chanlocs;

for cond = fields(EEG.ext.epochs)'
    s_cond = cond{1};
    for n = 1:length(EEG.ext.epochs.(s_cond))
        
        EEG.data = EEG.ext.epochs.(s_cond)(n).data;
        auxEEG = flt_laplace(EEG, neighs);
        EEG.ext.epochs.(s_cond)(n).data = auxEEG.data;
        
    end
end
EEG.data = [];

end