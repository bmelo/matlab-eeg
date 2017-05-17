function out = testChannels( mEEG, test )
%Testa �pocas
if nargin < 2, test = 'friedman'; end

switch( test )
    case 'testT'
        testH = @ttest2;
    case 'testF'
        testH = @vartest2;
    case 'wilcoxon'
        testH = @ranksum;
end

nChans = size(mEEG.T,2);
if strcmp( test, 'friedman' )
    for nC = 1:nChans
        means = [mEEG.T(:, nC) mEEG.A(:, nC) mEEG.nA(:, nC) mEEG.nT(:, nC)];
        %removing nans
        means = means(~any(isnan(means),2),:);
        % computing
        [results(nC).p, results(nC).table, results(nC).stats] = friedman( means, 1, 'off' );
    end
elseif strcmp( test, 'wilcoxon' )
    for nC = 1:nChans
        means = [mEEG.T(:, nC) mEEG.A(:, nC) mEEG.nT(:, nC) mEEG.nA(:, nC)];
        %removing nans
        means = means(~any(isnan(means),2),:);
        % computing
        [results(nC).T_N_p, results(nC).T_N_h, results(nC).T_N_stats] = testH( means(:,1),  means(:,3));
        [results(nC).A_N_p, results(nC).A_N_h, results(nC).A_N_stats] = testH( means(:,2),  means(:,4));
        [results(nC).T_A_p, results(nC).T_A_h, results(nC).T_A_stats] = testH( means(:,1),  means(:,2));
    end
    results = struct(...
        'T_N_p', [results(:).T_N_p], 'T_N', [results(:).T_N_h],...
        'A_N_p', [results(:).A_N_p], 'A_N', [results(:).A_N_h],...
        'T_A_p', [results(:).T_A_p], 'T_A', [results(:).T_A_h] ...
        );
else
    [results.T_N, results.T_N_p] = testH(mEEG.T, mEEG.nT);
    [results.A_N, results.A_N_p] = testH(mEEG.A, mEEG.nA);
    [results.T_A, results.T_A_p] = testH(mEEG.T, mEEG.A );
end
out = results;

end