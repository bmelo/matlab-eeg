function ini = getIniParalelo( sujeito, mascara, params )

%GETINIPARALELO Summary of this function goes here
%   Detailed explanation goes here
ini = load('default.mat');
ini.general.silent = '1'; %Sempre usar com este modo
ini.general.dirout = [fullfile( Individuo.dirOutSubj(sujeito), mascara, 'results') filesep]; %Sempre usar com este modo
ini.risco.mascara = fullfile( Individuo.dirOutSubj(sujeito), mascara, 'mask_RFI2.nii'); %Sempre usar com este modo
ini.risco.subject = sujeito;
ini.risco.numtrials = params.numTrials;
ini.risco.numvolstrial = params.numVolsTrial;
ini.risco.numruns = params.numRuns;
ini.risco.patternvol = params.patternVol;
ini.risco.runstreino = params.runsTreino;
ini.risco.runsteste = params.runsTeste;

end

