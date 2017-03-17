function signalERD = erd_ers(signal, window, overlap, same_density)
% ERD_ERS
% Details

if nargin < 4, same_density = 0; end;    

%eeg_mean = mean(signal);
%variance = var(signal);
relative_power = mpow( signal(1:window) );

win_overlap = window-overlap;

% Filling all values
signalERD = [];
for k = 1:win_overlap:length(signal)
    last = k+win_overlap-1;
    
    if last+overlap > length(signal)
        intervW = k:length(signal);
        intervM = intervW;
    else
        intervW = k:last;
        intervM = k:last+overlap;
    end
    
    mean_window = mpow( signal(intervM) );
    perc_change = (mean_window - relative_power) / relative_power * 100;
    
    % Checking if needs replicate value along the window lenght
    if same_density
        signalERD(intervW) = perc_change;
    else
        signalERD(end+1) = perc_change;
    end
end

end


function mpower = mpow(signal)
mpower = mean( signal.^2 );
end