function accs = chs_acc( dir_in, idxs, pattern )

if nargin < 2, idxs = 1:63; end
if nargin < 3, pattern = 'accs_chs_%02d'; end

accs = zeros(1, 63 );
for nC=idxs
    temp_accs = load( fullfile( dir_in, sprintf(pattern, nC) ) );
    accs(nC)  = median(median(temp_accs.accs,2));
end

end