function export_eeg_BVA( EEG, filename )
%EXPORT_EEG_BVA Summary of this function goes here
%   export_eeg_BVA(EEG)

mERD = matrices(EEG);

conds = fields(mERD);
for cond = conds'
    % selecting data
    mDATA = mERD.( cond{1} );
    
    % Removing unnecessary part
    srate = EEG.srate;
    int_del = floor(56 * srate) + 1; % to remove end
    mDATA(:,:,int_del:end) = []; % removing end
    
    % merging epochs
    mDATA = permute(mDATA, [1,3,2]);
    mDATA = mDATA(:,:);
    
    % exporting
    p.data = mDATA;
    p.srate = srate;
    p.channels = {EEG.chanlocs(:).labels};
    
    outfilename = fullfile(cond{1}, filename);
    export_eeglab( p, outfilename);
end

end

