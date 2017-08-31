function signalWin = window_func(signal, window, overlap, hfunc, varargin)
% WINDOW_FUNC -> Do windowing in the signal

if nargin < 4, hfunc = @median; end
if nargin < 5, varargin = {}; end

size_data = length(signal);
% is generating so many plots and wasting a lot of time
%{
fprintf('width: %1$d, overlap: %2$d, data size: %3$d, function <a href="matlab:help %4$s">%4$s</a>\n',...
    window, overlap, size_data, func2str(hfunc) ...
);
%}

win_overlap = window-overlap;

% Filling all values
signalWin = [];
for k = 1:win_overlap:size_data
    last = k+win_overlap-1;
    
    if last+overlap > length(signal)
        % Adjust to use always the window size specified. 
        % At end, will replicate the windows that are incomplete, repeating if necessary
        intervM = (length(signal)-window-1):length(signal);
        break;
    else
        intervM = k:last+overlap;
    end
    
    signalWin(end+1) = hfunc( signal(intervM), varargin{:} );
end

end