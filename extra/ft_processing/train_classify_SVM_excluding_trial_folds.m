function correct_rate = train_classify_SVM_excluding_trial_folds( x, y, x_desc )

current_trial_id = x_desc{1}(1:7);

current_trial = 1;
trials{current_trial} = 1;

k=2;
while k <= length(x_desc)
  
    if strcmp( x_desc{k}(1:7), current_trial_id)
        trials{current_trial}(end+1) = k;
    else
        current_trial_id = x_desc{k}(1:7);
        current_trial = current_trial + 1;
        trials{current_trial} = k;
    end

    k = k+1;
    
end


r = [];
groups = y;
reps = size(x,1);
for tr=1:length(trials)
    
    train               = ones(reps,1) == 1;
    train(trials{tr})   = 0==1;
    

    cp = classperf(groups);
    data = x;
    options = optimset('maxiter',1000);
    
    svmStruct = svmtrain(data(train,:),groups(train), 'quadprog_opts',options);
    
    
    for test_ind = trials{tr}
        classes = svmclassify(svmStruct,data(test_ind,:));
        test = ones(reps,1) == 0;
        test( test_ind ) = 1==1;
        classperf(cp,classes,test);
        r(test_ind) = cp.CorrectRate;
    end
    
%    fprintf( '%i of %i: correct %i \n ', rep, reps, r(rep) )
end
correct_rate = mean(r);
disp( sprintf( 'Mean correct rate over %i repetions of leave-trial-out training data: %1.2g', reps, correct_rate ) );

end