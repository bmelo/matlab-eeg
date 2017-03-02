function run_eeg()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)
%
includeDeps;
import utils.Msgs;

config = setup('subjs', 8);
clear results_SL;

close all;
for subjN = config.subjs
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    fprintf('\n\n\n####    %s   ####\n', subj);
    
    % Preproc
    if config.do.preproc
        load_data;
        %extract_matrix;
    end
    
    if config.do.first_level
        first_level;
    end
    
    %plot_eeg(EEG);
    %plot_cond(EEG);
    plot_sync_desync(epochs);
    
    input('[Enter] para continuar...');
    clear EEG results;
end

if( config.do.second_level )
    second_level;
end