function computes_glm_LORETA( outname )
curdir = pwd;

if nargin < 1, outname = 'export_pieces.txt'; end

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
    
    band = regexp(files{nF}, '\d{2}-\d{2}', 'match', 'once');
    band_label = regexprep(band, {'04-08' '08-13' '13-30' '30-45'}, {'theta' 'alpha' 'beta' 'gamma'});
    
    subjid = regexp(files{nF}, 'SUBJ\d+(?=\D)', 'match', 'once');
    
    nR = (nF-1)*2 + 2; % numRow
    % Preparing output data for Tenderness
    corrs{nR, 1} = subjid;
    corrs{nR, 2} = band;
    corrs{nR, 3} = band_label;
    corrs{nR, 4} = 'T';
    subplot(2,1,1); title('Ternura');
    [cT pT] = correlations(data, model_T, false, false, true);
    %[cT pT] = correlations(data(model_A==0, :), model_T(model_A==0), true, false, false);
    corrs(nR, 5:10) = num2cell(cT);
    
    % Preparing output data for Anguish
    corrs(nR+1, 1:3) = corrs(nR, 1:3); % Same subject and band
    corrs{nR+1, 4} = 'A';
    subplot(2,1,2); title('Angústia');
    [cA pA] = correlations(data, model_A, false, false, true);
    %[cA pA] = correlations(data(model_T==0,:), model_A(model_T==0), true, false, true);
    corrs(nR+1, 5:10) = num2cell(cA);
end

cd(curdir);
utils.geraOut(outname, corrs);

end

% Computes correlations between model and temporal series for each ROI
function [corrs p] = correlations( data, model, normparam, filterSignal, toPlot )  

if nargin < 3, normparam = false; end
if nargin < 4, filterSignal = false; end
if nargin < 5, toPlot = false; end

numCols = size(data, 2);

corrs = zeros(1, numCols);
p = corrs;

% Calculating correlation
for nC = 1:numCols
    % Normalizing model to the same space signal
    % don't influence results, but help in plots
    if ~normparam
        dataN = data(:,nC)';
    else
        dataN = data(:,nC)/norm(data(:,nC), Inf);
        dataN = dataN';
    end
    
    % Filtering signal
    dataFN = filterBin(dataN);
    
    % Doing correlation
    if filterSignal
        dataN = dataFN;
    end
    [corrs(nC) p(nC)] = corr( dataN', model' );
    
    % to check [debug]
    if toPlot && nC ==2
        plot(dataN/norm(dataN, Inf));
        hold on, plot(model,'r'), hold off; 
        ylim( [-0.1 1.1]);
        xlim([0 length(data)]);
    end
end

end

function outData = filterBin( data )
% Filtering signal
h = [1/2 1/2];
binomialCoeff = conv(h,h);
for n = 1:4
    binomialCoeff = conv(binomialCoeff,h);
end
outData = filter(binomialCoeff, 1, data)';
end

function outData = filterSG( data )
% Filtering signal
outData = sgolayfilt(data, 8, 501)';
end