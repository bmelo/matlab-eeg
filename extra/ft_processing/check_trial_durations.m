for k=1:length(data.time)
    trial_durations(k) = data.time{k}(end) - data.time{k}(1);
end

figure, hist(trial_durations, 100)