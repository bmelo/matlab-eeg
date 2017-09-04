classdef GA < utils.Generic
    %GA Summary of this class goes here
    %   GEN
    %   INDIVIDUAL
    
    properties
        classifier;
        studyDir = '';
        parallel = false;
        population = {};
        generations = {};
        populationSize = 20;
        probMut = 0.01;
        percDominante = 0.8;
        startTime = now; % Control
        finishTime; % Control
    end
    
    methods
        function obj=GA( sujeitos, areas, atlas )
            if nargin < 3 %O atlas tem valor default
                obj.classifier = Classifier( areas );
            else
                obj.classifier = Classifier( areas, atlas );
            end
            obj.classifier.studyDir = obj.studyDir;
            obj.sujeitos = sujeitos;
            
            % Compute max number of elements
            if(length(areas)<50)
                for k=1:length(areas)
                    obj.maxElements = obj.maxElements + nchoosek(48,k);
                end
            else
                obj.maxElements = Inf;
            end
        end
        
        
        function valor = continuesGA(obj)
            valor = true;
            if( isempty(obj.populacao{end}) | length(obj.populacao)>50 )
                valor = false;
            end
        end
        
        
        function executar(obj)
            fprintf('STARTING GA PROCESSING ...\n');
            if obj.paralelo & ~(matlabpool('size')>0) %Verifica se o matlabpool est� aberto
                matlabpool open 2;
            end
            obj.geraPopulacaoInicial();
            %Realiza o processamento do AG
            while( obj.continuesGA() )
                fprintf('\n\n******************************\n');
                fprintf('         POPULATION %02d\n', length(obj.populacao));
                obj.geracoes{end+1} = struct(); %Informa que uma nova gera��o ser� utilizada
                obj.processarPopulacao(); %Executa o processamento
                obj.reproduction(); %Efetua o cruzamento e as muta��es
            end
            if obj.paralelo
                matlabpool close;
            end
            obj.report();
        end
    end
    
    methods(Access = private)    
        %Add an element to actual population
        function adicionado = addInd(obj, ind, verExiste)
            adicionado = false;
            if(nargin<3)
                verExiste = true;
            end
            if(~ischar(ind))
                ind = ind.id;
            end
            if( ~verExiste | ~obj.existeMask( ind ) )
                obj.populacao{end}{end+1} = ind;
                adicionado = true;
            end
        end
        
        %Verifica se uma mascara j� existiu
        function out = existeMask( obj, mask, excluirUlt )
            if( ~exist('excluirUlt', 'var') )
                excluirUlt = false;
            end
            out = false;
            for k=1:(length(obj.populacao)-excluirUlt)
                for j=1:length(obj.populacao{k})
                    if strcmp(obj.populacao{k}{j}, mask)
                        out = true;
                    end
                end
            end
        end
        
        %Faz uma limpeza de elementos limpos ou duplicados da populacao corrente
        function limparPop(obj)
            %Eliminando elementos vazios
            pos = cellfun(@isempty, obj.populacao{end});
            obj.populacao{end}(pos) = [];
            %@TODO: eliminar elementos duplicados
        end
                
        function insertRandomMasks(obj, num)
            for k = 1:num
                obj.addInd( obj.classifier.gerarMaskAleatoria() );
            end
        end
        
        %Gera a populacao inicial com todas areas individualizadas
        function geraPopulacaoInicial(obj)
            fprintf('Doing initial population');
            %Verifica se precisa gerar uma populacao do zero
            if(~isempty(obj.populacao)) %Continuando AG interrompido
                obj.reproduction();
            else
                numAreas = length(obj.classifier.areas);
                obj.populacao{1} = cell( (numAreas*2)+1 , 1); %Armazena o total de mascaras
                cont = 1;
                mask = Mascara(obj.classifier.atlas);
                %Inserindo a m�scara com todas as �reas
                mask.addAreas(obj.classifier.areas);
                obj.populacao{1}{cont} = mask.id;
                mask.removeAreas(obj.classifier.areas);
                for area = obj.classifier.areas %Primeiro insere cada mascara individualmente
                    cont = cont+1;
                    mask.addAreas(area);
                    if(~isempty(mask.listValues()))
                        obj.populacao{1}{cont} = mask.id;
                    end
                    mask.removeAreas(area);
                end
                obj.insertRandomMasks(numAreas); %Completa a popula��o com mascaras aleat�rias
                obj.limparPop();
            end
        end
        
        % Processa cada indiv�duo da popula��o
        function processarPopulacao( obj )
            iniTimePP = now; %Initial Time of Population Processing
            fprintf('-- Processing elements (%03d):\n\n', length(obj.populacao{end}));
            pop = obj.populacao{end}; %Recebe a popula��o para usar no processamento paralelo
            %skipping elements already calculated
            limpar =[];
            cont = 0;
            for k = 1:length(pop)
                if(obj.existeMask(pop(k),true))
                    cont = cont+1;
                    fprintf('%03d - *%s [00:00:00]\n', cont, pop{k}); %Printando log
                    limpar(cont) = k;
                end
            end
            pop(limpar) = [];
            tamPop = length(pop);
            %Processamento paralelo
            if obj.paralelo
                params = obj.classifier.toStruct();
                params.sujeitos = obj.sujeitos;                
                %Classifing elements
                parfor k = 1:tamPop
                    start = now;
                    Classifier.classificarParalelo( pop{k}, params );
                    tempo = datestr(now-start, 13);
                    fprintf('%s [%s]\n', pop{k}, tempo); %Printando log
                end
            %Processamento sequencial
            else
                for k = 1:tamPop
                    cont = cont+1;
                    fprintf('%03d - %s ', cont, pop{k}); %Printando log
                    start = now;
                    obj.classifier.classificar( Individuo(pop{k}, obj.sujeitos) );
                    tempo = datestr(now-start, 13);
                    fprintf('[%s]\n', tempo); %Printando log
                end
            end
            obj.alimentaDadosGeracao(); %Salva informa��es importantes da gera��o atual
            fprintf('Total processing time: [%s]\n', datestr(now-iniTimePP, 13)); %Printando log
        end
        
        %Armazena resultados e o que for necessario da populacao atual
        function alimentaDadosGeracao(obj)
            globalMean = zeros(length(obj.populacao{end}),1);
            for k = 1:length(obj.populacao{end})
                individuo  = Individuo( obj.populacao{end}{k}, obj.sujeitos );
                obj.geracoes{end}.masks(k).id = obj.populacao{end}{k};
                obj.geracoes{end}.masks(k).results = individuo.getResults();
                obj.geracoes{end}.masks(k).mean = mean2( obj.geracoes{end}.masks(k).results );
                globalMean(k) = obj.geracoes{end}.masks(k).mean;
            end
            obj.geracoes{end}.mean = mean(globalMean);
            obj.sortGeracao();
            geracoes = obj.geracoes;
            populacao = obj.populacao;
            save('temp_data.mat', 'geracoes', 'populacao'); %Salva dados tempor�rios para poder recuperar processamento
        end
        
        function cruzamento(obj, popTemp)
            fprintf('\n  -- CRUZAMENTO\n');
            groups = cell(3,1);
            groups{1} = popTemp; %Elementos em ordem
            groups{2} = Shuffle(popTemp); %Elementos bagun�ados
            %Mais evolu�dos bagun�ados e casados com menos evolu�dos, tamb�m bagun�ados
            middle = floor(length(popTemp)/2); %Indica a metade
            groups{3} = [ Shuffle(popTemp(1:middle)); Shuffle(popTemp(middle+1:end)) ];                
            for k=1:3 %Combina os indiv�duos 3 vezes, gerando mais descendentes
                popCruz = groups{k};
                while(length(popCruz) > 1)
                    %Verificar cromossomos que s�o diferentes e cruz�-los (selecionar uma posi��o de apenas um indiv�duo)
                    ind1 = popCruz{1};
                    ind2 = popCruz{2};
                    popCruz(1:2) = [];
                    posicoes = Shuffle( unique( [Mascara.CodeToAreas(ind1) Mascara.CodeToAreas(ind2)] ) );
                    mask = Mascara(obj.classifier.atlas);
                    areas = posicoes(1:2);
                    posicoes(1:2) = [];
                    while( ~isempty(posicoes) )
                        if( rand() < obj.percDominante )
                            areas = [areas posicoes(end)];
                        end;
                        posicoes(end) = [];
                    end
                    mask.addAreas(areas);
                    if( obj.addInd( mask ) )
                        %fprintf( '       * %10s + %s -> %s\n', ind1, ind2, mask.id );
                    end
                end
            end
            fprintf('      Members generated: %d', length(obj.populacao{end}) );
        end
        
        function mutacao(obj)
            fprintf('\n  -- MUTA��ES\n');
            %Percorre todas as �reas de todos os indiv�duos atuais e muda de acordo com a probabilidade
            tamPop = length(obj.populacao{end});
            for k=1:tamPop %Percorre os membros da popula��o
                maskPai = obj.populacao{end}{k};
                mask = Mascara.getMaskByCode( maskPai );
                for j=obj.classifier.areas %Percorre as �reas informadas
                    if( rand()<obj.probMut ) %Verifica se ocorreu muta��o
                        if( mask.hasArea(j) )
                            mask.removeAreas(j);
                        else
                            mask.addAreas(j);
                        end
                    end
                end
                if( ~strcmp(mask.id, maskPai )) %S� insere o ind�viduo se ocorreu muta��o
                    %fprintf( '       * %10s -> %s\n', maskPai, mask.id );
                    obj.addInd( mask, false );
                end
            end
            fprintf('      Members generated: %d', length(obj.populacao{end}) - tamPop );
        end
        
        % Do crossover and mutations
        function reproduction(obj)
            obj.populacao{end+1} = {};
            fprintf('\n-- Reproduction of actual population');
            %Cruzamento (soma todas as areas de duas mascaras aleatorias)
            popTemp = obj.selecaoNatural();
            obj.cruzamento(popTemp);
            fprintf('\n   Total Members: %d', length(obj.populacao{end}));
        end
        
        %Select most evoluted elements
        function popTemp = selecaoNatural(obj)
            fprintf('\n-- Selecting members for the next generation');
            tam = length(obj.geracoes{end}.masks);
            popTemp = cell(tam,1); %Armazena o total de mascaras
            cont = 0;
            limiar = min( [(58.0 + (length(obj.populacao)*0.5)) 100] );
            for k=1:tam
                avalia = all( any( obj.geracoes{end}.masks(k).results > 55.0 ) );
                avalia = avalia & obj.geracoes{end}.masks(k).mean > limiar;
                if avalia;
                    cont = cont+1;
                    popTemp{cont} = obj.geracoes{end}.masks(k).id;
                end
            end
            if(cont < tam)
                popTemp(cont+1:tam) = [];
            end
            fprintf('\n   Total Members: %d', length(popTemp));
        end
        
        %Sort last generation by mean
        function sortGeracao(obj)
            Afields = fieldnames(obj.geracoes{end}.masks);
            Acell = struct2cell(obj.geracoes{end}.masks);
            sz = size(Acell);
            Acell = reshape(Acell, sz(1), []);
            Acell = Acell';
            Acell = sortrows(Acell, -3);
            Acell = reshape(Acell', sz);
            obj.geracoes{end}.masks = cell2struct(Acell, Afields, 1);
        end
    end
end