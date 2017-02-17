classdef cEEG
    %TIME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static = true)
        
        function listCanais(  )
            global EEG;
            canais = { EEG.chanlocs.labels };
            for k=1:length(canais); 
                fprintf( '%d - %s\n', k, canais{k} ); 
            end
        end
        
        function sinal = janelas( epocas, windowLength )
            [nC, nPoints] = size(epocas);
            nParts = floor( nPoints/windowLength );
            endS = nParts*windowLength;
            sinal = reshape( epocas(:,1:endS), nC, nParts, [] );
        end
        
        function sinal = join( epocas )
            sinal = [];
            for k=1:length(epocas)
                sinalSemMedia = []; %
                %Removing the mean
                for nC = 1:63
                    sinalSemMedia(nC, :) = epocas(k).data(nC, :) - mean(epocas(k).data(nC,:));
                end
                sinal = [sinal sinalSemMedia];
            end
        end
        
        %Faz a promediação utilizando janelas (bom para ERP)
        function media = promediacao( epocas, janela )
            if( nargin < 2 ) %Calcula a janela
                janela = 1000;
            end
            janelas = {};
            totalC = size( epocas(1).data, 1 );
            for k=1:length(epocas)
                nParts = floor( size( epocas(k).data, 2 ) / janela );
                for nC = 1:totalC
                    janelas{k,end+1:end+23} = reshape( epocas(k).data(nC, 1:nParts*janela), [], janela );
                end
            end
        end
        
        function printReport( results, title, sumDim, th )
            if ~exist('sumDim', 'var'); sumDim = 2; end;
            if ~exist('th', 'var'); th = [0 1]; end;
            
            fprintf(title);
            
            %% Reporting results
            global EEG;
            canais = { EEG.chanlocs.labels };
            
            %sels = [1 2 5 11 14 17 22 25 29 53]; % Fp1 Fp2 C3 F7 T8 Fz FC2 FC5 TP9 AF8
            %sels = 1:63;
            
            %RUNs com tarefa melhor executada no TEST001 (apenas RUNS 1 e 2)
            conds = {'TERNURA', 'ANGUSTIA'};
            for c = 1:length(conds)
                cond = conds{c};
                rSum = sum(results.(cond),sumDim);
                %disp(' '); fprintf('%d ', rSum );disp(' ');
                fprintf('\n## %s ##\n', cond);
                fprintf('CANAIS: %s\n', sprintf('%s ', canais{ rSum >= th(1) } ));
                if( th(2) > th(1) )
                    fprintf('MELHORES: %s\n', sprintf('%s ', canais{ rSum >= th(2) } ));
                end
            end
        end
    end
    
end

