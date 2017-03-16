function signalERD = erd_ers(signal, window, overlap)
% ERD_ERS
% Details

%eeg_mean = mean(signal);
%variance = var(signal);

relative_power = mpow( signal(1:window) );
win_overlap = window-overlap;
signalERD(1:win_overlap) = 0;

for k = win_overlap+1:win_overlap:length(signal)
    last = k+window;
    if last > length(signal)
        last = length(signal);
    end
    
    mean_window = mpow( signal(k:last) );
    perc_change = (mean_window - relative_power) / relative_power * 100;
    
    signalERD(k:last) = perc_change;
end

end


function mpower = mpow(signal)
mpower = mean( signal.^2 );
end