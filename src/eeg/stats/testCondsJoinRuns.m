function results = testCondsJoinRuns( epochs, test )
%%%
% JUNTA TODAS OS EVENTOS E TESTA COMO SE FOSSE UMA SÉRIE SEM INTERRUPÇÃO
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
results.TERNURA = testar( testH, taskT, neutroT );
results.ANGUSTIA = testar( testH, taskA, neutroA );

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