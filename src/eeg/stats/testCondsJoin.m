function results = testCondsJoin( epochs, test )
%%%
% JUNTA TODAS OS EVENTOS DENTRO DE UM RUN E TESTA
% GERA RESULTADOS PARA CADA RUN TESTADO
% NÃO SEPARA BANDAS
%%%
if( ~exist('test', 'var') ); test = 'testF'; end;
switch( test )
    case 'testF'
        testH = @vartest2;
    case 'wilcoxon'
        testH = @ranksum;
end

nChannels = size(epochs.TASK_T(1).data,1);
nRuns = 2;
results.TERNURA = ones( nRuns, nChannels );
results.ANGUSTIA = ones( nRuns, nChannels );

for nR = 1:nRuns
    pos = (nR-1)*4 + 1;
    posN = (nR-1)*8 + 1;
    taskT = cEEG.join( epochs.TASK_T(pos:pos+3) );
    neutroT = cEEG.join( epochs.NEUTRAL(posN:posN+3) );
    taskA = cEEG.join( epochs.TASK_A(pos:pos+3) );
    neutroA = cEEG.join( epochs.NEUTRAL(posN+4:posN+7) );
    results.TERNURA(nR,:) = testar( testH, taskT, neutroT );
    results.ANGUSTIA(nR,:) = testar( testH, taskA, neutroA );
end

end

%Testando com Test F
function h = testar( fH, cond1, cond2 )

h = ones( size(cond1,1), 1 );
for nE = 1:size(cond1,1) %Percorre todos os canais
    ds1 = spectral_density( cond1(nE,:) );
    ds2 = spectral_density( cond2(nE,:) );
    h(nE) = fH( ds1, ds2 );
end

end