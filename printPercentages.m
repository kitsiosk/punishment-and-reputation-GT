function printPercentages(L)
    sz = size(L);
    N = sz(1)*sz(2);
    fprintf('Number of 0s: %0.2f%% \nNumber of 1s: %0.2f%% \nNumber of 2s: %0.2f%% \nNumber of 3s: %0.2f%% \n',...
            100*sum(L(:) == 0)/N, 100*sum(L(:) == 1)/N, 100*sum(L(:) == 2)/N, 100*sum(L(:) == 3)/N)
end