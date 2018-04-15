function accs = chs_acc( dir_in, idxs, pattern )

if nargin < 2, idxs = 1:63; end
if nargin < 3, pattern = 'accs_chs_%02d'; end

accs = zeros(1, 63);
maxSubjs = 6;
for nC=idxs
    try
        temp_accs = load( fullfile( dir_in, sprintf(pattern, nC) ) );
    catch
        continue
    end
    medians = median(temp_accs.accs,2);
    medians = sort(medians, 'descend');
    %accs(nC) = mean(medians(1:maxSubjs));
    accs(nC) = median(medians);
end

end