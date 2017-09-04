function getIni( individuo, params )

dirOut = fullfile(CONSTS.OUTPUT_DIR, individuo.sujeito);

ini = load('default.mat');
ini.general.silent = '1'; %Sempre usar com este modo
ini.general.dirout = fullfile(dirOut, individuo.mascara.id); %Sempre usar com este modo
ini.risco.mascara = fullfile(dirOut, individuo.mascara.id, 'mask_RFI2.nii'); %Sempre usar com este modo
ini.risco.subject = individuo.sujeito;
ini.risco.numtrials = params.numTrials;
ini.risco.numvolstrial = params.numVolsTrial;
ini.risco.numruns = params.numRuns;
ini.risco.patternvol = params.patternVol;
ini.risco.runstreino = params.runsTreino;
ini.risco.runsteste = params.runsTeste;