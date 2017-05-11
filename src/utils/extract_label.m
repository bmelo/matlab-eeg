function [ label ] = extract_label( filename )
%EXTRACT_LABEL Summary of this function goes here
%   Detailed explanation goes here

parts = regexp(filename, '_', 'split', 'once');
label = strrep(parts{2}, '_', '-');

end

