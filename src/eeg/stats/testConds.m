function out = testConds( EEG, test )
%Testa Épocas
if nargin < 2, test = 'friedman'; end

for nB = 1:length(EEG)
    srate = EEG(nB).srate;
    epochs = EEG(nB).ext.epochs;
    switch( test )
        case 'testF'
            testH = @vartest2;
        case 'wilcoxon'
            testH = @ranksum;
    end
    
    intN = floor( [0 10] * srate );
    intC = floor( [20 46] * srate );
    % Only works with equal number of conditions
    for k = 1:length(epochs.TASK_T)
        nT(:, k) = eeg_extract_means( epochs.TASK_T(k), intN);
        T(:, k) = eeg_extract_means( epochs.TASK_T(k), intC);
        nA(:, k) = eeg_extract_means( epochs.TASK_A(k), intN);
        A(:, k) = eeg_extract_means( epochs.TASK_A(k), intC);
    end
    
    if strcmp( test, 'friedman' )
        for nchan = 1:size(T,1)
            results(nchan) = friedman( [T(nchan, :)' A(nchan, :)' nA(nchan, :)' nT(nchan, :)'], 1, 'off' );
        end
    else
        results.T_N = testH( T', nT');
        results.A_N = testH( A', nA');
        results.T_A = testH( T', A' );
    end
    out(nB) = results;
end

end