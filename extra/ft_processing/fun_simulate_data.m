function simulated_data = fun_simulate_data( data, trial_groups )

%% insere nos trials certos 
simulated_data = data;

% find trials
for g=1:length(trial_groups)

    trials_li = zeros( length( data.hdr.orig.event ), 1 );

    trial_ids = trial_groups{g}
    for k=1:length(trial_ids)

        trials_li = trials_li | strcmp( { data.hdr.orig.event.type }' ,  trial_ids{k} );

    end

    start_inds = [data.hdr.orig.event(trials_li).latency];

    %% created simulated signal for the trials
    time_win = 30;
    theta = simulate_signal( time_win, data.hdr.Fs, 6 );
    alfa = simulate_signal( time_win, data.hdr.Fs, 10 );
    beta = simulate_signal( time_win, data.hdr.Fs, 20 );
    
    before = 5 * data.hdr.Fs ;
    after  = 5 * data.hdr.Fs ;
    trans = 1 * data.hdr.Fs ;
    transline = linspace(0,g*1,trans);
    
    timeline = [zeros(1,before) , transline, g*ones(1,length(theta)-before-after-2*trans) , max(transline) - transline, zeros(1,after) ];
    
    trial_simulation = timeline .* theta + (max(transline) - timeline ) .*alfa + (max(transline) - timeline ) .* beta;

    % random noise over whole run
    simulated_data.trial{1} = randn( size( simulated_data.trial{1} ) );
    
    n_chans = size( simulated_data.trial{1} ,1 );
    
    % put signal for every trial and all channels
    for t=1:length(start_inds)
        a = start_inds(t)-before;
        b = a+length(trial_simulation)-1;
        simulated_data.trial{1}( : , a:b ) = simulated_data.trial{1}( : , a:b ) + repmat( trial_simulation, [ n_chans 1] );
    end

end

end

function signal = simulate_signal( time_win, fs, f )

    time_pnts = 0: 1/fs :time_win;
    time_pnts(end) = [];
    
    signal = sin( 2*pi*f*time_pnts );
    
end

