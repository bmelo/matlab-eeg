function [ varargout ] = prepare_matrix( mEEG, srate, clean_nan )
%PREPARE_MATRIX Summary of this function goes here
%   Detailed explanation goes here

if nargin<3, clean_nan = 0; end

n_wins = size(mEEG.TASK_T, 3);

% Neutral condition is doubled (excerpt for Tenderness and Anguish)
intN  = floor( [2 10] * srate ); % 8s - selected to have the same size of the condition
intNF = floor( [57 62] * srate ); % 5s - selected to have the same size of the condition
intC  = floor( [20 46] * srate ); % 26s

idxN = [intN(1)+1:intN(2)  intNF(1)+1:intNF(2)];
idxN(idxN > n_wins) = [];
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

% If is active, remove NaN lines (excluded channels)
if clean_nan
    lines_ok = ~any(isnan(out.T),2);
    out.T = out.T( lines_ok,:);
    out.A = out.A( lines_ok,:);
    out.N = out.N( lines_ok,:);
end

% Controlling outputs
if nargout == 1
    varargout = {out};
else
    varargout = {out ~lines_ok};
end

end

% Created just to easily read some parts of the code
function vec = vector( mat )
vec = reshape(mat, 1, []);
end

