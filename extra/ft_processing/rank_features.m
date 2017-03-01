function [data data_25] = rank_features( data )

x = zscore(data.x);

y_classes = unique( data.y );
num_classes = length(y_classes);

mu_x = mean(x);

for c=1:num_classes
    
    ind_c = data.y == y_classes(c);
    mu_x_within(c,:) = mean( x(ind_c,:) ); 
    var_x_between(c,:) = ( mu_x_within(c,:) - mu_x ).^2;
    var_x_within(c,:) = 1/(sum(ind_c)-1) * sum( ( x(ind_c,:) - repmat(mu_x_within(c,:),sum(ind_c),1) ).^2 );

end
    
F =  sum( var_x_between ) ./ sum( var_x_within );

[F_s, I] = sort(F,'descend');

figure, plot( sort(F,'descend') );

data_25 = data;
data_25.x = data.x(:,I(1:ceil(length(F)/4)));
if isfield( data, 'features' ) && isfield( data.features, 'desc' )
    data_25.features.desc = data.features.desc(I(1:ceil(length(F)/4)));
end

