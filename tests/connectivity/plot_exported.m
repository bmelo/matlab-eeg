chan_names = {EEG.chanlocs.labels};
% ---> PDC
figure('Name','Partial Directed Coherence (PDC)','NumberTitle','off');
plot_con_matrix(PDC, chan_names);
% ---> DTF
figure('Name','Directed Transfer Function (DTF)','NumberTitle','off'); % ---> DTF
plot_con_matrix(DTF, chan_names);