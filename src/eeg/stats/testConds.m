function out = testConds( EEG, test )
% Testing epochs
if nargin < 2, test = 'friedman'; end

for nB = 1:length(EEG)
    srate = EEG(nB).srate;
    epochs = EEG(nB).data;
    switch( test )
        case 'testF'
            testH = @vartest2;
        case 'wilcoxon'
            testH = @ranksum;
    end
    
    intN1 = get_interval( [5 10], srate );
    intN2 = get_interval( [56 61], srate );
    intC  = get_interval( [20 46], srate );
    
    % Extracting pieces
    nT1 = epochs.TASK_T(:,:, intN1);
    nT2 = epochs.TASK_T(:,:, intN2);
    T   = epochs.TASK_T(:,:, intC);
    nA1 = epochs.TASK_A(:,:, intN1);
    nA2 = epochs.TASK_A(:,:, intN2);
    A   = epochs.TASK_A(:,:, intC);
    
    m_nT1 = median(nT1, 3);
    m_nT2 = nanmedian(nT2, 3);
    m_T   = nanmedian(T,   3);
    m_nA1 = nanmedian(nA1, 3);
    m_nA2 = nanmedian(nA2, 3);
    m_A   = nanmedian(A,   3);
    
    % Testing
    if strcmp( test, 'friedman' )
        for nchan = 1:size(T,1)
            %results(nchan) = friedman( [T(nchan, :)' A(nchan, :)' nA(nchan, :)' nT(nchan, :)'], 1, 'off' );
            % Checando condições neutras
            cols   = remove_nan( [nT1(nchan, :)' nT2(nchan, :)' nA1(nchan, :)' nA2(nchan, :)'] );
            m_cols = remove_nan( [m_nT1(nchan, :)' m_nT2(nchan, :)' m_nA1(nchan, :)' m_nA2(nchan, :)'] );
            if ~isempty(cols)
                results.raw(nchan)    = friedman( cols, 5*srate, 'off' );
                results.median(nchan) = friedman( m_cols, 1, 'off' );
            end
        end
    else
        results.T_N = testH( T', nT');
        results.A_N = testH( A', nA');
        results.T_A = testH( T', A' );
    end
    out = results;
end

end

% Returns interval in datapoints
function interv = get_interval( lims, srate )
lims = floor( lims * srate );
interv = (lims(1)+1):lims(2);
end