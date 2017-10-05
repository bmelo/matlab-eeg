rois  = {'T_OFC' 'T_SEPT' 'T_PRECUNEUS' 'A_RIGHT_AMYG' 'A_DLPFC_RIGHT' 'A_DLPFC_LEFT'};
bands = {'theta' 'alpha' 'beta' 'gamma'};
offset = 5;

idxT = strcmp(medians_loreta(:,4), 'T');

for nB = 1:4
    band = bands{nB};    
    idxB = strcmp(medians_loreta(:,3), band);
    
    for nRoi = 1:6
        roi = rois{nRoi};
        valsT = medians_loreta( (idxB &  idxT), offset + nRoi);
        valsA = medians_loreta( (idxB & ~idxT), offset + nRoi);
        
        [h, p] = ttest2( cell2mat(valsT), cell2mat(valsA) );
        fprintf('h=%d, p=%.3f  [%s x %s]\n', h, p, band, roi);
    end
end