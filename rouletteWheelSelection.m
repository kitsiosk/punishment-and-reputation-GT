function k = rouletteWheelSelection(fitness)
% Choose an index with probability proportional to the fitness

% Find cumulative sum of normalized fitness in [0,1]
% fitness_cdf = cumsum(fitness/sum(fitness));
sum_fitness = 0;
for i=1:length(fitness)
    if( fitness(i) > 0 )
        sum_fitness = sum_fitness + fitness(i);
    end
end
% Choose k with probability proportionate to diff
for k = 1:length(fitness)
    random_num = rand();
    if random_num <= fitness(k)/sum_fitness
        return
    end
end

k = -1;

end