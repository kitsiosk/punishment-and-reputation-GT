%% INITIALIZATION
clear
close all

% Type of game: 'Simple', 'Punishment', 'Reputation'
mode = 'Simple';
if strcmp(mode, 'Simple')
    L = unidrnd(2,M,N) - 1;
    % meet function handle
    meet = @meetSimple;
    
elseif strcmp(mode, 'Punishment')
    L = randi([0 3], M, N);
    % meet function handle
    meet = @meetPunishment;
    fprintf('Initial percentage of cooperators: %0.2f %% \n', ...
        (sum(L(:) == 1) + sum(L(:) == 3)) * 100 / (M * N))
    printPercentages(L)
    
elseif strcmp(mode, 'Reputation')
    % meet function handle
    meet = @meetReputation;
    % TODO
else
    fprintf("Invalid mode entered.\n")
    fprintf("Please enter 'Simple', 'Punishment' or 'Reputation'.\n")
    return
end

% Dimentions of lattice
M = 100;
N = 100;

% Number of rounds
T = 3000;

% Investment multiplication factor
% r = 2.2;
rArr = 1:0.1:3;
frequencies = zeros(length(rArr), 4);
% Cost of cooperation
c = 1;
% Fee of punisher for each defector
gamma = 1;
% Fee of defector for each punisher
beta = 1.5;

% Score matrix initialization
P = zeros(M,N);

for rr = 1:length(rArr)
% Set rate
r = rArr(rr);

% Strategy matrix (randomly generated)
% 0 for defectors
% 1 for cooperators
% 2 for defectors with punishment( 'punishment' mode only )
% 3 for cooperators with punishment( 'punishment' mode only )
% rng(1)
% L = unidrnd(2,M,N) - 1;
L = randi([0 3], M, N);
fprintf('Initial percentage of cooperators for r=%0.2f: %0.2f %% \n', ...
    r, (sum(L(:) == 1) + sum(L(:) == 3)) * 100 / (M * N))
printPercentages(L)

% Every 100 rounds check the frequencies of the previous checkpoint. If
% they are the same then skip the rest rounds to save time
prev0 = 0;prev1 = 0;prev2 = 0;prev3 = 0;
for t = 1:T
%% INTERACTION STAGE

% Score matrix initialization
P = zeros(M,N);

for t = 1:T
    %% INTERACTION STAGE
    
    % For every point in the lattice
    for i = 1:M
        for j = 1:N
            
            % Find neighbors
            R = getNeighbors(i,j,M,N);
            lR = length(R);
            
            % For every neighbor
            for k = 1:(lR-1)
                P(i,j) = P(i,j) + meet(L(i,j), L(R(k)), L(R(k+1)), ...
                    r, c, beta, gamma);
            end
            
            % If there are more than two neighbors,
            % then meet with the last and first neighbor
            % and find the mean score
            if lR > 2
                P(i,j) = P(i,j) + meet(L(i,j), L(R(k)), L(R(k+1)), ...
                    r, c, beta, gamma);
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
            
            imitationNeighboor = rouletteWheelSelection(diff);
            if imitationNeighboor ~= -1
                L(i,j) = L(R(imitationNeighboor));
            end
            
        end
    end
    
    % Convergence condition to avoid uneccessary rounds
    epsilon = 0.1;
    if( mod(t, 100) == 0 )

        if( abs(sum(L(:) == 0) - prev0)/(M*N) < epsilon && ...
            abs(sum(L(:) == 1) - prev1)/(M*N) < epsilon && ...
            abs(sum(L(:) == 2) - prev2)/(M*N) < epsilon && ...
            abs(sum(L(:) == 3) - prev3)/(M*N) < epsilon )
            break
        end
        % Update frequencies every 100 rounds
        prev0 = sum(L(:) == 0);
        prev1 = sum(L(:) == 1);
        prev2 = sum(L(:) == 2);
        prev3 = sum(L(:) == 3);
        
        pp = (sum(L(:) == 1) + sum(L(:) == 3)) * 100 / (M * N);
        fprintf('Percentage of cooperators at round %d and for r=%0.2f: %f%% \n', t, r, pp)
        printPercentages(L);
    end
    
end
frequencies(rr, 1) = sum(L(:) == 0);
frequencies(rr, 2) = sum(L(:) == 1);
frequencies(rr, 3) = sum(L(:) == 2);
frequencies(rr, 4) = sum(L(:) == 3);
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
