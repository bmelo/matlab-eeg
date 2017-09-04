classdef Individuo < utils.Generic
    %Individuo Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        maskId;
        sujeitos;
        coef;
        results = {};
    end
    
    methods
        function obj = Individuo( mascara, sujeitos )
            if( ischar(mascara) )
                obj.maskId = mascara;
            else
                obj.maskId = mascara.id;
            end
            obj.sujeitos = sujeitos;
            obj.results = [];
        end
        
        %Retorna o coeficiente de adaptação
        function out = getResults( obj )
            if(isempty(obj.results))
                obj.results = zeros(length(obj.sujeitos), 1);
                for k=1:length(obj.sujeitos)
                    resultsDir = fullfile(obj.dirOutSubj(obj.sujeitos{k}), obj.maskId, 'results');
                    files = dir( fullfile(resultsDir, 'resultado*.txt') );
                    if(isempty(files))
                        return;
                    end
                    for j=1:length(files)
                        filename = regexp(fullfile(resultsDir, files(j).name), 'resultado\d+\.txt', 'match');
                        if( isempty(filename) )
                            continue;
                        end
                        caminho = fullfile(resultsDir, filename{1});
                        acc = regexp( fileread(caminho), 'Accuracy = (\d+\.*\d*)%', 'tokens');
                        try
                            obj.results(k,j) = str2num(acc{1}{1});
                        catch E
                            sprintf('ERRO! Algum problema ocorreu ao resgatar as acuracias de %s', obj.maskId);
                            disp(E.message);
                        end
                    end
                end
            end
            out = obj.results;
        end
        
        %Retorna o coeficiente de adaptação
        function coef = getAdaptacao(obj)
            regexp(fileread(caminho), 'Accuracy = (\d+\.\d+)%', 'tokens');
        end
        
        function pasta = dirOut( obj, ind )
            pasta = fullfile( Individuo.dirOutSubj(obj.sujeitos{ind}), obj.maskId );
        end
    end
    
    methods (Static = true)
        %Retorna a pasta do output de cada sujeito, criando-a se necessário
        function pasta = dirOutSubj( sujeito )
            pasta = fullfile(CONSTS.OUTPUT_DIR, sujeito );
            if( ~exist(pasta, 'dir') )
                mkdir(pasta);
            end
        end
        
        %Levanta a mascara e retorna para o sujeito
        function mascara = getMask( maskId )
            mascara = Mascara.getMaskByCode(maskId);
        end
        
        function limparFiles(sujeito, mascara)
            dirAtual = pwd;
            cd( fullfile(CONSTS.OUTPUT_DIR, sujeito, mascara, 'results' ) ); 
            delete *.nii *.model
            cd(dirAtual);
        end
    end
end