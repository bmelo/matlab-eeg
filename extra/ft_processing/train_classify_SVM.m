function correct_rate = train_classify_SVM( x, y )
r = [];
groups = y;
reps = size(x,1);
rep = zeros(reps,1);
for rep=1:reps
    train = ones(reps,1) == 1;
    train(rep) = 0==1;
    test = ~train;
%    [train, test] = crossvalind('holdOut',groups, 0.1)
    cp = classperf(groups);
    data = x;
    options = optimset('maxiter',1000);
    if size(data,2) == 2
        svmStruct = svmtrain(data(train,:),groups(train),'showplot',true);
        classes = svmclassify(svmStruct,data(test,:),'showplot',true);
    else
        svmStruct = svmtrain(data(train,:),groups(train), 'quadprog_opts',options);
        classes = svmclassify(svmStruct,data(test,:));
    end
    classperf(cp,classes,test);
    r(rep) = cp.CorrectRate;
    
%    fprintf( '%i of %i: correct %i \n ', rep, reps, r(rep) )
end
correct_rate = mean(r);
disp( sprintf( 'Mean correct rate over %i repetions of leave-one-out training data: %1.2g', reps, correct_rate ) );

end