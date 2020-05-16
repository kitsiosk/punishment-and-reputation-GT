function k = rouletteWheelSelection(fitness)
% Choose an index with probability proportional to the fitness

% Sort fitness
[fitness, idx] = sort(fitness);

% Find cumulative sum of normalized fitness in [0,1]
fitness_cdf = cumsum(fitness/sum(fitness));

random_num = rand();

for i = 1:length(fitness)
    if random_num <= fitness_cdf(i)
        k = idx(i);
        return
    end
end

end