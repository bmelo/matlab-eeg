function Population = creation_function( GenomeLength, FitnessFcn, options )
%CREATION_FUNCTION Summary of this function goes here
%   Detailed explanation goes here

popSize = options.PopulationSize;
comb = 2;

Population = zeros(popSize, GenomeLength);
for k = 1:options.PopulationSize
    new = randi([1 63], 1, comb);
    Population(k, new) = 1;
end

end
