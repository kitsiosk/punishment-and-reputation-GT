%% INITIALIZATION
clear
close all

% Type of game: 'simple', 'punishment', 'reputation'
mode = 'punishment';

% Dimentions of lattice
M = 100;
N = 100;

% Number of rounds
T = 2000;

% Investment multiplication factor
r = 2;
% Cost of cooperation
c = 1;
% Fee of punisher for each defector
gamma = 1;
% Fee of defector for each punisher
beta = 1.5;

% Strategy matrix (randomly generated)
% 0 for defectors
% 1 for cooperators
% 2 for defectors with punishment( 'punishment' mode only )
% 3 for cooperators with punishment( 'punishment' mode only)
% rng(1)
% L = unidrnd(2,M,N) - 1;
L = randi([0 3], M, N);
fprintf('Initial percentage of cooperators: %0.2f %% \n', ...
    (sum(L(:) == 1) + sum(L(:) == 3)) * 100 / (M * N))
printPercentages(L)

% Score matrix initialization
P = zeros(M,N);
perc = []; % percentages array

for t = 1:T
%% INTERACTION STAGE
    if mod(t, 10) == 0
        pp = (sum(L(:) == 1) + sum(L(:) == 3)) * 100 / (M * N);
        fprintf('Percentage of cooperators at round %d: %f%% \n', t, pp)
        printPercentages(L);
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
                if( strcmp(mode, 'simple') )
                    P(i,j) = P(i,j) + meet(L(i,j), L(R(k)), L(R(k+1)), r, c);
                elseif( strcmp(mode, 'punishment') )
                    P(i,j) = P(i,j) + meetPunish(L(i,j), L(R(k)), L(R(k+1)), ...
                        r, c, beta, gamma);
                end     
            end
            
            % If there are more than two neighbors,
            % then meet with the last and first neighbor
            % and find the mean score
            if lR > 2
                if( strcmp(mode, 'simple') )
                    P(i,j) = P(i,j) + meet(L(i,j), L(R(lR)), L(R(1)), r, c);
                elseif( strcmp(mode, 'punishment') )
                    P(i,j) = P(i,j) + meetPunish(L(i,j), L(R(lR)), L(R(1)), ...
                        r, c, beta, gamma);
                end
%                 P(i,j) = P(i,j) + meet(L(i,j),L(R(lR)),L(R(1)),r,c);
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
tm = (1:T/100)*100;
plot(tm, perc);
xlabel('round')
ylabel('Cooperators percentage')

fprintf('Final percentage of cooperators: %0.2f %% \n', ...
    (sum(L(:) == 1) + sum(L(:) == 3)) * 100 / (M * N))