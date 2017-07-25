function out_signal = remove_outliers(signal, window, overlap)
% REMOVE_OUTLIERS - Details

slide_size = window - overlap;
out_signal = signal;
thre = 3;

% Calculating all stds
n_wins = ceil( (length(signal) - slide_size) / slide_size );
stds = zeros(1, n_wins);
for k = 1 : n_wins
    stds(k) = std( signal( intervs(k) ) );
end

% Defining intervals
outliers = find( stds > median(stds) * thre );
n_otls = length(outliers);
replace = [];
k = 1;
while k <= n_otls
    replace(end+1, 1:2) = outliers(k);
    k = k+1;
    for kk = k:n_otls
        diff_otls = outliers(kk)-outliers(kk-1);
        % Checking if is in a sequence of outliers
        if diff_otls > ceil( window / (slide_size+1) )
            break
        end
        replace(end, 2) = outliers(kk);
        k = k+1;
    end
end

% Replacing outliers with adjacents means
n_deletes = size(replace,1);
for k = 1:n_deletes
    idxs = intervs( replace(k,:) );
    
    idx_adjs = [];
    if (idxs(1)-window-1) > 1
        idx_adjs = (idxs(1)-window) : idxs(1)-1;
    end
    if (idxs(end)+window+1) < length(signal)
        idx_adjs = [idx_adjs idxs(end)+1 : (idxs(end)+window)];
    end
    mean_adjs = mean( signal(idx_adjs) );
    out_signal(idxs) = mean_adjs;
end

debug = 0;
if debug && n_deletes > 0
    close all;
    fprintf('!! Removed %d outliers !!\n', n_deletes);
    plot(signal); hold on; for k=outliers, plot(intervs(k), signal(intervs(k))); end, hold off;
    figure, plot(out_signal); hold on; for k=outliers, plot(intervs(k), out_signal(intervs(k)), 'r'); end, hold off;
    input('[Enter]');
end

% #####################
% # SUBFUNCTIONS
% #####################

%% Subfunction to calculate idxs of windows
    function idxs = intervs( pos  )
        if pos(1) > n_wins, return; end
        
        pos_start = (pos(1)-1) * slide_size + 1;
        pos_end = pos_start + window - 1;
        if pos(1) == n_wins
            pos_end = length(signal);
        end
        
        idxs = pos_start:pos_end;
        % Grouping adjacent sequences
        if length(pos) == 2 && pos(2) > pos(1)
            idxs2 = intervs(pos(2));
            idxs = pos_start:max(idxs2);
        end
    end

end