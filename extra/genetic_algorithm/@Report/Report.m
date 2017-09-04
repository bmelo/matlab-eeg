classdef Report < utils.Generic
    %REPORT Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Static = true)
        %Retorna um relatório com todas as acurácias de todas as máscaras usadas em um sujeito
        function out = results( sujeito )
            out = Report.resultsPath( Individuo.dirOutSubj(sujeito) );
        end
        
        %Limpa as pastas de todos os sujeitos
        function cleanAllMasks()
            subjects = dir( CONSTS.OUTPUT_DIR );
            for k=1:length(subjects)
                Report.cleanMasksSubj( subjects(k).name );
            end
        end
        
        function cleanMasksSubj( subject )
            root = fullfile(CONSTS.OUTPUT_DIR, subject);
            masks = dir( root );
            for k=1:length(masks)
                if strcmp(masks(k).name, '.' ) | strcmp(masks(k).name, '..' )
                    continue;
                end
                maskDir = fullfile(root, masks(k).name);
                if(~exist( fullfile(maskDir, 'results'), 'dir' ))
                    rmdir(maskDir, 's');
                end
            end
        end
    end
    
end

