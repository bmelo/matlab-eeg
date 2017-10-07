function extract_averages_LORETA( outname )
curdir = pwd;

if nargin < 1, outname = 'export_psc.txt'; end

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
conds = {'T' 'A'};

rows = {'SUBJID' 'BANDA' 'BANDA LABEL' 'CONDIÇÃO' 'TRIAL' 'T_OFC' 'T_SEPT' 'T_PRECUNEUS' 'A_RIGHT_AMYG' 'A_DLPFC_RIGHT' 'A_DLPFC_LEFT'};
nR = 2;
for nF = 1:length(files)
    data = csvread(files{nF}, 1, 0);
    
    band = regexp(files{nF}, '\d{2}-\d{2}', 'match', 'once');
    band_label = regexprep(band, {'04-08' '08-13' '13-30' '30-45'}, {'theta' 'alpha' 'beta' 'gamma'});
    
    subjid = regexp(files{nF}, 'SUBJ\d+(?=\D)', 'match', 'once');
    
    for nC = 1:length(conds)
        cond = conds{nC};
        avgs = eval(['psc(data, model_' cond ');']);
        
        for nA = 1:size(avgs,1)
            rows{nR, 1} = subjid;
            rows{nR, 2} = band;
            rows{nR, 3} = band_label;
            rows{nR, 4} = cond;
            rows{nR, 5} = nA;
            rows(nR, 6:11) = num2cell(avgs(nA, :));
            
            % Next line
            nR = nR+1;
        end
    end
end

cd(curdir);
utils.geraOut(outname, rows);
assignin('base', 'medians_loreta', rows);

end