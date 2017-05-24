function signalERD = window_func(signal, window, overlap, hfunc, varargin)
% ERD_ERS
% Details

win_overlap = window-overlap;

% Filling all values
signalERD = [];
for k = 1:win_overlap:length(signal)
    last = k+win_overlap-1;
    
    if last+overlap > length(signal)
        intervM =  k:length(signal);
    else
        intervM = k:last+overlap;
    end
    
    signalERD(end+1) = hfunc( signal(intervM), varargin{:} );
end

end