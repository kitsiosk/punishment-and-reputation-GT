function k = rouletteWheelSelection(fitness)
% Choose an index with probability proportional to the fitness

% Find cumulative sum of normalized fitness in [0,1]
fitness_cdf = cumsum(fitness/sum(fitness));

random_num = rand();

for k = 1:length(fitness)
    if random_num <= fitness_cdf(k)
        return
    end
end

end