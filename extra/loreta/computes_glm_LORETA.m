function computes_glm_LORETA( outname )
curdir = pwd;

if nargin < 1, outname = 'export.txt'; end

%% # Option 1
%input_dir = '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/PROC_DATA/EEG/Exports/LORETA_SINGLE_SUBJECT_FULL';
%nPoints = 89600;

%% # Option 2
input_dir = '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/PROC_DATA/EEG/Exports/ERD_ERS_SINGLE_SUBJECT';
nPoints = 1120;

%% Setup
srate = nPoints/16/56;

files = utils.resolve_names(fullfile(input_dir, '*T.csv'));

% Soft model - considers that during the 10 initial seconds, the emotion gradually increases
limN = ceil( srate*10 );
model_soft = [zeros(1,limN-1) 0:1/(limN+1)*srate:1 ones(1, nPoints/16-ceil(srate*20)+1) ];

model = [zeros(1,limN-1) ones(1, (nPoints/16) - limN + 1)];
model_active = repmat(model, 1, 16);
model_zeros = zeros(1,nPoints);

bandas = {'alpha' 'beta' 'gamma'};

corrs = {'SUBJID' 'BANDA' 'EMOÇÃO' 'T_OFC' 'T_SEPT' 'T_PRECUNEUS' 'A_RIGHT_AMYG' 'A_DLPFC_RIGHT' 'A_DLPFC_LEFT'};
for nF = 1:length(files)
    data.T = csvread(files{nF}, 1, 0);
    data.A = csvread( strrep(files{nF}, '_T.csv', '_A.csv'), 1, 0);
    
    fileName = regexprep(files{nF}, {'8-13' '13-26' '26-45'}, {'alpha' 'beta' 'gamma'});
    
    subjid = regexp(fileName, 'SUBJ\d+(?=\D)', 'match', 'once');
    banda = regexp(fileName, 'alpha|beta|gamma', 'match', 'once');
    
    nR = (nF-1)*2 + 2; % numRow
    % Preparing output data for Tenderness
    corrs{nR, 1} = subjid;
    corrs{nR, 2} = banda;
    corrs{nR, 3} = 'T';
    [c p] = correlations([data.T; data.A], [model_active model_zeros], false, false, false);
    corrs(nR, 4:9) = num2cell(c);
    
    % Preparing output data for Anguish
    corrs(nR+1, 1:2) = corrs(nR, 1:2); % Same subject and band
    corrs{nR+1, 3} = 'A';
    [c p] = correlations([data.T; data.A], [model_zeros model_active], false, false, false);
    corrs(nR+1, 4:9) = num2cell(c);
end

cd(curdir);
utils.geraOut(outname, corrs);

end

% Computes correlations between model and temporal series from each ROI
function [corrs p] = correlations( data, model, normparam, filterSignal, toPlot )  

if nargin < 3, normparam = false; end
if nargin < 4, filterSignal = false; end
if nargin < 5, toPlot = false; end

[nPoints numCols] = size(data);
idxT = 1:(nPoints/2);
idxA = (nPoints/2)+1:nPoints;

corrs = zeros(1, numCols);
p = corrs;

% Calculating correlation
for nC = 1:numCols
    % Normalizing model to the same space signal
    % don't influence results, but help in plots
    if ~normparam
        dataN = data(:,nC)';
    else
        dataN(idxT) = data(idxT,nC)/norm(data(idxT,nC), normparam);
        dataN(idxA) = data(idxA,nC)/norm(data(idxA,nC), normparam);
    end
    
    % Filtering signal
    dataFN = filterBin(dataN);
    
    % Doing correlation
    if filterSignal
        dataN = dataFN;
    end
    [corrs(nC) p(nC)] = corr( dataN', model' );
    
    % to check [debug]
    if toPlot
        subplot(2,1,1);
        plot(dataN/norm(dataFN, Inf)), hold on, plot(model,'r'), hold off; ylim( [-0.1 1.1] );
        subplot(2,1,2);
        plot(dataFN/norm(dataFN, Inf)), hold on, plot(model,'r'), hold off; ylim( [-0.1 1.1] );
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