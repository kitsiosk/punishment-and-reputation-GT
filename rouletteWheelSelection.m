function k = rouletteWheelSelection(fitness)
% Choose an index with probability proportional to the fitness

% Find sum of positive fitness
fitness(fitness < 1e-6) = 0;
sum_fitness = sum(fitness);

% Choose k with probability proportionate to fitness
for k = 1:length(fitness)
    random_num = rand();
    if random_num <= fitness(k)/sum_fitness
        return
    end
end

k = -1;

end