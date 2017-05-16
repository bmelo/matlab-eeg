function out = testChannels( matrixEEG, srate, test )
%Testa �pocas
if nargin < 2, test = 'friedman'; end

switch( test )
    case 'testF'
        testH = @vartest2;
    case 'wilcoxon'
        testH = @ranksum;
end

intN = floor( [0 10] * srate );
intC = floor( [20 46] * srate );
% Only works with equal number of conditions
for nC = 1:size(matrixEEG.TASK_T,1)
    nT(:, nC) = mean( matrixEEG.TASK_T(nC, :, intN(1)+1:intN(2)), 3);
    T(:, nC)  = mean( matrixEEG.TASK_T(nC, :, intC(1)+1:intC(2)), 3);
    nA(:, nC) = mean( matrixEEG.TASK_A(nC, :, intN(1)+1:intN(2)), 3);
    A(:, nC)  = mean( matrixEEG.TASK_A(nC, :, intC(1)+1:intC(2)), 3);
end

if strcmp( test, 'friedman' )
    for nchan = 1:size(T,1)
        [results.resp(nchan) results.p(nchan)] = friedman( [T(nchan, :)' A(nchan, :)' nA(nchan, :)' nT(nchan, :)'], 1, 'off' );
    end
else
    [results.T_N results.T_N_p] = testH(T, nT);
    [results.A_N results.A_N_p] = testH(A, nA);
    [results.T_A results.T_A_p] = testH(T, A );
end
out = results;

end