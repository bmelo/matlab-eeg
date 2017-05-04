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
    pw_mean.TASK_T(k,:,:) = squeeze(mean(epochs.TASK_T,2));
    pw_mean.TASK_A(k,:,:) = squeeze(mean(epochs.TASK_A,2));
    
    sync_mean.TASK_T(k,:,:) = erd_ers( pw_mean.TASK_T(k,:,:), srate, srate/5 );
    sync_mean.TASK_A(k,:,:) = erd_ers( pw_mean.TASK_A(k,:,:), srate, srate/5 );
    
    clear EEG;
end

pw_grand.TASK_T = squeeze( mean(pw_mean.TASK_T, 1)  );
pw_grand.TASK_A = squeeze( mean(pw_mean.TASK_A, 1)  );

sync_grand = epochs_apply_matrices( @erd_ers, pw_grand, srate, srate/5 );

%data;
%grand_mean = squeeze(mean(pw_mean.TASK_T));
%plot( squeeze(mean(pw_mean.TASK_T))' );

end