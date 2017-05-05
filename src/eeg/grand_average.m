function grand_average( config, filename )

fprintf('\n####   GRAND AVERAGE - %s   ####\n\n', filename);

totalN = length(config.subjs);

srate = [];
close all;

% Extracting values
for k = 1:totalN
    subjN = config.subjs(k);
        
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    subjdir = fullfile( config.outdir_base, subj );
        
    EEG = eeg_load( subjdir, filename );
       
    % Validation
    if ~isempty(srate) && srate ~= EEG.srate
        error('Sample rate not matching!');
    end
    srate = EEG.srate;
    
    EEG = epochs_shrink( EEG, 46*srate );
    epochs = matrices(EEG);
    %data(k) = epochs;
    pw_mean(k).TASK_T(:,:) = squeeze(mean(epochs.TASK_T,2));
    pw_mean(k).TASK_A(:,:) = squeeze(mean(epochs.TASK_A,2));
    
    sync_mean(k) = epochs_apply_matrices(@erd_ers, pw_mean(k), srate, srate/5 );
    sync_mean(k) = epochs_apply_matrices(@erd_ers, pw_mean(k), srate, srate/5 );
    
    clear EEG;
end

sizeT = size(pw_mean(1).TASK_T);
merge.TASK_T = reshape( [pw_mean(:).TASK_T], sizeT(1), sizeT(2), []);
pw_grand.TASK_T = squeeze( mean(merge.TASK_T, 3)  );

sizeA = size(pw_mean(1).TASK_A);
merge.TASK_A = reshape( [pw_mean(:).TASK_A], sizeA(1), sizeA(2), []);
pw_grand.TASK_A = squeeze( mean(merge.TASK_A, 3)  );

sync_grand = epochs_apply_matrices( @erd_ers, pw_grand, srate, srate/5 );

%data;
plot(sync_grand.TASK_T(1,:));
%grand_mean = squeeze(mean(pw_mean.TASK_T));
%plot( squeeze(mean(pw_mean.TASK_T))' );

end