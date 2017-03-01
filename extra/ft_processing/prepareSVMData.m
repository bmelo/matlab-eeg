y = data_features{end}
y( find(y>1) ) = 2;
ind = find(y==0);
data_features_formatted( ind, : ) = [];
x = abs(data_features_formatted);
y(ind) = [];

%% run svm
groups = y;
[train, test] = crossvalind('holdOut',groups);
cp = classperf(groups);
data = x;
svmStruct = svmtrain(data(train,:),groups(train),'showplot',true);
classes = svmclassify(svmStruct,data(test,:),'showplot',true);
classperf(cp,classes,test);
cp