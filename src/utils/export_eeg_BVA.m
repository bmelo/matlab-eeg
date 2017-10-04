function export_eeg_BVA( EEG, filename )
%EXPORT_EEG_BVA Summary of this function goes here
%   export_eeg_BVA(EEG)

mERD = matrices(EEG);

conds = fields(mERD);
allDATA = [];

% Merging conditions
for run = 1:4
    first_E = (run-1) * 4 + 1;
    last_E  = run * 4;
    
    for cond = conds'
        % selecting data
        mDATA = mERD.( conds{1} )(:, first_E:last_E, : );
        
        % Removing unnecessary part
        srate = EEG.srate;
        int_del = floor(66 * srate) + 1; % to remove end
        mDATA(:,:,int_del:end) = []; % removing end
        
        % merging epochs
        mDATA = permute(mDATA, [1,3,2]);
        allDATA = [allDATA mDATA(:,:)];
    end
end


% exporting
p.data = [allDATA allDATA(:,end)]; % Repeating last position to use as terminator
p.srate = srate;
p.channels = {EEG.chanlocs(:).labels};

export_eeglab( p, filename);

end