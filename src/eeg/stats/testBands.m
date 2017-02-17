function results = testBands( epochs, test )
%%%
% JUNTA TODOS OS EVENTOS E TESTA COMO SE FOSSEM UMA SÉRIE CORRIDA
% NÃO SEPARA BANDAS
%%%
if( ~exist('test', 'var') ); test = 'testF'; end;
switch( test )
    case 'testF'
        testH = @vartest2;
    case 'wilcoxon'
        testH = @ranksum;
end

nRuns = 2;
posT = []; posA = []; posNT = []; posNA = [];
for nR = 1:nRuns
    pos = (nR-1)*4+1;
    posN = (nR-1)*8 + 1;
    posT = [posT pos:pos+3];
    posNT = [posNT posN:posN+3];
    posA = [posA pos:pos+3];
    posNA = [posNA posN+4:posN+7];
end
taskT = cEEG.join( epochs.TASK_T(posT) );
neutroT = cEEG.join( epochs.NEUTRAL(posNT) );
taskA = cEEG.join( epochs.TASK_A(posA) );
neutroA = cEEG.join( epochs.NEUTRAL(posNA) );
results.TERNURA = testar( testH, cEEG.janelas( taskT, 1000 ), cEEG.janelas( neutroT, 1000 ) );
results.ANGUSTIA = testar( testH, cEEG.janelas( taskA,1000) , cEEG.janelas( neutroA, 1000 ) );

end

%Testando com Test F
function h = testar( fH, cond1, cond2 )

[~,f] = spectral_density( squeeze( cond1(1,1,:) ) );
h = ones( size(cond1,1), length(f) );
for nC = 1:size(cond1,1) %Percorre todos os canais
    for nW = 1:size(cond1,2)
        part = cond1(nC, nW, :) - mean( cond1(nC, nW, :) );
        ds1(nW, :) = spectral_density( squeeze( part ) );
    end
    for nW = 1:size(cond2,2)
        part = cond2(nC, nW, :) - mean( cond2(nC, nW, :) );
        ds2(nW, :) = spectral_density( squeeze( part ) );
    end
    h(nC, :) = fH( ds1, ds2 );
end

end