function [ meanEEG ] = mean_matrix( mEEG, srate )
%MEAN_MATRIX Summary of this function goes here
%   Detailed explanation goes here

intN = floor( [0 10] * srate );
intC = floor( [20 46] * srate );
% Only works with equal number of conditions
for nC = 1:size(mEEG.TASK_T,1)
    meanEEG.nT(:, nC) = mean( mEEG.TASK_T(nC, :, intN(1)+1:intN(2)), 3, 'omitnan');
    meanEEG.T (:, nC) = mean( mEEG.TASK_T(nC, :, intC(1)+1:intC(2)), 3, 'omitnan');
    meanEEG.nA(:, nC) = mean( mEEG.TASK_A(nC, :, intN(1)+1:intN(2)), 3, 'omitnan');
    meanEEG.A (:, nC) = mean( mEEG.TASK_A(nC, :, intC(1)+1:intC(2)), 3, 'omitnan');
end

end

