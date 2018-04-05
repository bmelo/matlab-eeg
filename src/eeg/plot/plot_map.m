function plot_map( signal, chanlocs, varargin )
%PLOT_MAP Summary of this function goes here
%   Detailed explanation goes here

msignal = mean(signal, 2);
idx_rm = isnan(msignal);

msignal(idx_rm) = [];
chanlocs(idx_rm) = [];

topoplot(msignal, chanlocs, varargin{:});

end

