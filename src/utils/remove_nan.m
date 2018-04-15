function [ out ] = remove_nan( data )
%REMOVE_NAN Exclude lines with NaN values

lines_notNaN = ~any(isnan(data),2);
out = data( lines_notNaN,:);

end

