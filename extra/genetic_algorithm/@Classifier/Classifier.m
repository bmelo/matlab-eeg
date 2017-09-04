classdef Classifier < utils.Generic
    %CLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        areas;
        atlas = brodmann;
        silent = true;
        studyDir = '';
        volBase = 'vol_base.nii';
        pattern = 'fMRI*_mc_g.nii';
        patternVol = 'fMRI*_';
        runsTreino = 1:2;
        runsTeste = 3:4;
        numRuns = 4;
        numTrials = 25;
        numVolsTrial = 10;
        baseline = 1:2;
        activation = 3:4;
        preProc = false;
    end
    
    methods
        %Construtor
        function obj = Classifier( areas, atlas )
            obj.areas = areas;
            if(nargin > 2)
                obj.atlas = atlas;
            end
        end
        
        %Retorna uma máscara aleatória, podendo limitar o número de regiões selecionadas
        function mascara = gerarMaskAleatoria(obj, numAreas)
            if ~exist('numAreas', 'var'); numAreas=randi( length(obj.areas) ); end;
            mascara = Mascara( obj.atlas );
            areasSorted = zeros(1,numAreas);
            for num = 1:numAreas
                area = obj.areas( randi(length(obj.areas)) ); %Seleciona uma área aleatoria dentre as areas
                while any(areasSorted==area)
                    area = obj.areas( randi(length(obj.areas)) ); %Seleciona uma área aleatoria dentre as areas
                end
                areasSorted(num) = area;
            end
            mascara.addAreas( areasSorted );
        end
        
        %Recebe uma mascara como entrada, utilizando para classificar o sujeito
        function classificar(obj, individuo)
            mascara = Individuo.getMask( individuo.maskId );
            for k=1:length(individuo.sujeitos)
                inPath = fullfile(obj.studyDir, individuo.sujeitos{k}); %Dir onde as imagens estão
                if( ~exist(fullfile(individuo.dirOut(k),'mask_RFI2.nii'), 'file') )
                    mascara.converterBaseSubj( fullfile(inPath, 'vol_base.nii'), individuo.dirOut(k) ); %Coloca a mascara no espaco do sujeito
                end
                %Executar processamento
                obj.struct2ini( fullfile(individuo.dirOut(k), 'params.txt'), obj.getIni(individuo, k) ); %Gera o arquivo ini
                AnaliseRisco( fullfile(individuo.dirOut(k), 'params.txt') ); %Executa a classificação
                Individuo.limparFiles(individuo.sujeitos{k}, individuo.maskId);
            end
        end
        
        %Prepara arquivo ini para o sujeito indicado
        function ini = getIni( obj, individuo, pos )
            ini = load('default.mat');
            ini.general.silent = num2str(obj.silent); %Sempre usar com este modo
            ini.general.dirout = [fullfile( individuo.dirOut(pos), 'results') filesep]; %Sempre usar com este modo
            ini.risco.mascara = fullfile( individuo.dirOut(pos), 'mask_RFI2.nii'); %Sempre usar com este modo
            ini.risco.subject = individuo.sujeitos{pos};
            ini.risco.numtrials = obj.numTrials;
            ini.risco.numvolstrial = obj.numVolsTrial;
            ini.risco.numruns = obj.numRuns;
            ini.risco.patternvol = obj.patternVol;
            ini.risco.runstreino = obj.runsTreino;
            ini.risco.runsteste = obj.runsTeste;
            ini.risco.baseline = obj.baseline;
            ini.risco.activation = obj.activation;
            ini.risco.forcepreprocess = num2str(obj.preProc);
        end
        
    end
    
    methods (Static = true)
        dados = ini2struct(FileName);
        struct2ini(filename, Structure);
        classificarParalelo( maskId, params );
        ini = getIniParalelo( sujeito, mascara, params );
    end
    
end