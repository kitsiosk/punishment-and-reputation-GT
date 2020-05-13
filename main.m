%% INITIALIZATION
clear
close all

% Dimentions of lattice
M = 600;
N = 600;

% Number of rounds
T = 100;

% Investment multiplication factor
r = 3;
% Cost of cooperation
c = 1;

% Strategy matrix (randomly generated)
% 1 for cooperators
% 0 for defectors
rng(0)
L = unidrnd(2,M,N) - 1;
fprintf('Initial percentage of cooperators: %0.2f %% \n', sum(L(:)) * 100 / (M * N))

% Score matrix initialization
P = zeros(M,N);
perc = []; % percentages array

for t = 1:T
%% INTERACTION STAGE
    if mod(t, 100) == 0
        pp = sum(L(:)) * 100 / (M * N);
        fprintf('Percentage of cooperators at round %d: %f%% \n', t, pp)
        perc = [perc; pp];
    end
    % For every point in the lattice
    for i = 1:M
        for j = 1:N
            
            % Find neighbors
            R = getNeighbors(i,j,M,N);
            lR = length(R);
            
            % For every neighbor
            for k = 1:(lR-1)
                P(i,j) = P(i,j) + meet(L(i,j),L(R(k)),L(R(k+1)),r,c);
            end
            
            % If there are more than two neighbors,
            % then meet with the last and first neighbor
            % and find the mean score
            if lR > 2
                P(i,j) = P(i,j) + meet(L(i,j),L(R(lR)),L(R(1)),r,c);
            end
            P(i,j) = P(i,j) / lR;

        end
    end
    
%% IMITATION/REPRODUCTION STAGE
    
    % For every point in the lattice
    for i = 1:M
        for j = 1:N
            
            % Find neighbors
            R = getNeighbors(i,j,M,N);
            
            % Difference of the scores compared to the neighbors
            diff = P(R) - P(i,j);
            
%             % Exclude neighbors with lower or equal scores from imitation
%             negative_diff = diff < 1e-6;
%             R(negative_diff) = [];
%             diff(negative_diff) = [];
            
            imitationNeighboor = rouletteWheelSelection(diff);
            if imitationNeighboor ~= -1
                L(i,j) = L(R(imitationNeighboor));
            end
            
        end
    end
    
end

%% Plot results
figure(1)
plotHex(L)
title('Final grid')
figure(2)
tm = (1:t)*100;
plot(tm, perc);
xlabel('round')
ylabel('Cooperators percentage')

fprintf('Final percentage of cooperators: %0.2f %% \n', sum(L(:)) * 100 / (M * N))