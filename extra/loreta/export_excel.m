curdir = pwd;

%input_dir = '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/PROC_DATA/EEG/Exports/LORETA_SINGLE_SUBJECT_FULL';
input_dir = '/dados2/PROJETOS/PRJ1411_NFB_VR/03_PROCS/PROC_DATA/EEG/Exports/ERD_ERS_SINGLE_SUBJECT';
cd(input_dir);
files = utils.resolve_names('*.csv');

nPoints = 1120;
srate = nPoints/16/56;
limN = ceil( srate*10 );
model = [zeros(1,limN-1) 0:1/(limN+1)*srate:1 ones(1, nPoints/16-ceil(srate*20)+1) ];
model_full = repmat(model, 1, 16);
bandas = {'alpha' 'beta' 'gamma'};

corrs = {};
for nF = 1:length(files)
    data = csvread(files{nF}, 1, 0);
    
    fileName = regexprep(files{nF}, {'8-13' '13-26' '26-45'}, {'alpha' 'beta' 'gamma'});
    
    banda = regexp(fileName, 'alpha|beta|gamma', 'match', 'once');
    emocao = files{nF}(end-4);
    
    % Extracts relevant info
    corrs{nF, 1} = files{nF};
    corrs{nF, 2} = banda;
    corrs{nF, 3} = emocao;
    
    % Calculating correlation
    for nR = 1:size(data,2)
        
        % Normalizing model to the same space signal
        % don't influence results, but help in plots
        dataN = data(:,nR)/norm(data(:,nR),Inf);
        
        % Doing correlation
        [c p] = corr( dataN, model_full' );
        corrs{nF, 4 + (nR-1) * 2} = c;
        corrs{nF, 5 + (nR-1) * 2} = p;
        
        % to check
        %plot(dataN), hold on, plot(model_full,'r'), hold off;
    end
end

cd(curdir);
utils.geraOut('export.txt', corrs);