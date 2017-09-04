function classificarParalelo( maskId, params )

mascara = Individuo.getMask( maskId );
for k=1:length(params.sujeitos)
    subj = params.sujeitos{k};
    inPath = fullfile( params.studyDir, subj ); %Dir onde as imagens estão
    outPath = fullfile( Individuo.dirOutSubj(subj), maskId ); %Dir onde os resultados serão colocados
    mascara.converterBaseSubj( fullfile(inPath, 'vol_base.nii'), outPath ); %Coloca a mascara no espaco do sujeito
    %Executar processamento
    Classifier.struct2ini( fullfile(outPath, 'params.txt'), Classifier.getIniParalelo( subj, maskId, params )); %Gera o arquivo ini
    AnaliseRisco( fullfile(outPath, 'params.txt') ); %Executa a classificação
    Individuo.limparFiles( subj, maskId);
end