function computes_glm_LORETA( outname )
curdir = pwd;

if nargin < 1, outname = 'export_medians.txt'; end

% INPUT
input_dir = '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/PROC_DATA/EEG/Exports/LORETA_EEG_SINGLE_SUBJECT';
srate = 250;
[events, ~] = events_matrix(srate);
events = events-1;
events( events==2 ) = -1;

model_T = events;
model_T(model_T < 0) = 0;

model_A = events * -1;
model_A(model_A < 0) = 0;

files = utils.resolve_names(fullfile(input_dir, '*.csv'));

corrs = {'SUBJID' 'BANDA' 'BANDA LABEL' 'CONDIÇÃO' 'T_OFC' 'T_SEPT' 'T_PRECUNEUS' 'A_RIGHT_AMYG' 'A_DLPFC_RIGHT' 'A_DLPFC_LEFT'};
for nF = 1:length(files)
    data = csvread(files{nF}, 1, 0);
    
    plotLORETA(data(:,6), events);
    
    band = regexp(files{nF}, '\d{2}-\d{2}', 'match', 'once');
    band_label = regexprep(band, {'04-08' '08-13' '13-30' '30-45'}, {'theta' 'alpha' 'beta' 'gamma'});
    
    subjid = regexp(files{nF}, 'SUBJ\d+(?=\D)', 'match', 'once');
    
    nR = (nF-1)*2 + 2; % numRow
    % Preparing output data for Tenderness
    corrs{nR, 1} = subjid;
    corrs{nR, 2} = band;
    corrs{nR, 3} = band_label;
    corrs{nR, 4} = 'T';
    [cT pT] = correlations(data, model_T, false, false);
    %[cT pT] = correlations(data(model_A==0, :), model_T(model_A==0), true, false);
    corrs(nR, 5:10) = num2cell(cT);
    
    % Preparing output data for Anguish
    corrs(nR+1, 1:3) = corrs(nR, 1:3); % Same subject and band
    corrs{nR+1, 4} = 'A';
    
    [cA pA] = correlations(data, model_A, false, false, true);
    %[cA pA] = correlations(data(model_T==0,:), model_A(model_T==0), true, false, true);
    corrs(nR+1, 5:10) = num2cell(cA);
end

cd(curdir);
utils.geraOut(outname, corrs);

end


% to check [debug]
function plotLORETA(data, model)

% Plotting time series
subplot(2,1,1);
data(end-2000:end) = [];
plot(data/norm(data, Inf));
ylim( [-0.1 1.1]);
xlim([0 length(data)]);
title('Time Series', 'FontSize', 16);

% Plotting model
subplot(2,1,2);
model(end-2000:end) = [];
plot(model,'r');
ylim( [-1.1 1.1]);
xlim([0 length(data)]);
title('Model', 'FontSize', 16);

end