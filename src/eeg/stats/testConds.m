function results = testConds( epochs, test )
%%%
% TESTA CADA EVENTO DE FORMA SEPARADA
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
results.TERNURA = ones( nRuns*4, nChannels );
results.ANGUSTIA = ones( nRuns*4, nChannels );

for nR = 1:nRuns
    pos = (nR-1)*4 + 1;
    for nT = 1:8
        posN = (nR-1)*8 + nT;
        if( nT < 5 )
            posT = pos+nT-1;
            results.TERNURA(posT,:) = testar( testH, epochs.TASK_T(posT), epochs.NEUTRAL(posN) );
        else
            posT = pos+nT-5; %Pos Task
            results.ANGUSTIA(posT,:) = testar( testH, epochs.TASK_A(posT), epochs.NEUTRAL(posN) );
        end
    end
end

end

%Testando com Test F
function h = testar( fH, cond1, cond2 )

h = ones( size(cond1.data,1), 1 );
for nE = 1:size(cond1.data,1) %Percorre todos os canais
    ds1 = spectral_density( cond1.data(nE,:) );
    ds2 = spectral_density( cond2.data(nE,:) );
    h(nE) = fH( ds1, ds2 );
end

end