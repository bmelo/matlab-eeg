function [ out ] = prepare_matrix( mEEG, srate )
%PREPARE_MATRIX Summary of this function goes here
%   Detailed explanation goes here

% Neutral condition is doubled (excerpt for Tenderness and Anguish)
intN  = floor( [2 10] * srate ); % 8s - selected to have the same size of the condition
intNF = floor( [57 62] * srate ); % 5s - selected to have the same size of the condition
intC  = floor( [20 46] * srate ); % 26s

idxN = [intN(1)+1:intN(2)  intNF(1)+1:intNF(2)];
idxC = intC(1)+1:intC(2);

num_chs = size( mEEG.TASK_T, 1 );
% Only works with equal number of conditions
for nC = 1 : num_chs    
    out.N(nC, :) = [
        vector( mEEG.TASK_T(nC, :, idxN) ) ... 
        vector( mEEG.TASK_A(nC, :, idxN) )
    ];
    out.T(nC, :) = reshape( mEEG.TASK_T(nC, :, idxC), 1, [] );
    out.A(nC, :) = reshape( mEEG.TASK_A(nC, :, idxC), 1, [] );
end

end

function vec = vector( mat )
vec = reshape(mat, 1, []);
end

