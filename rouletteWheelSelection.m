function k = rouletteWheelSelection(fitness)
% Choose an index with probability proportional to the fitness

% Find cumulative sum of normalized fitness in [0,1]
% fitness_cdf = cumsum(fitness/sum(fitness));

% Choose k with probability proportionate to diff
for k = 1:length(fitness)
    random_num = rand();
    if random_num <= fitness(k)/sum(fitness)
        return
    end
end

k = -1;

end