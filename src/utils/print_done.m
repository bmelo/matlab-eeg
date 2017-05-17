function [ output_args ] = print_done( s )
%PRINT_DONE Summary of this function goes here
%   Detailed explanation goes here

time = toc(s);
fprintf('Done (%.2f s).\n\n', time);

end

