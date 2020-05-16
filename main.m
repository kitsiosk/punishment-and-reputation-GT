%% INITIALIZATION
clear
close all

% Type of game: 'Simple', 'Punishment', 'Reputation'
mode = 'Punishment';
if strcmp(mode, 'Simple')
    % Minimum and maximum strategy numbers (See strategy matrix below)
    minStr = 0;
    maxStr = 1;
    % meet function handle
    meet = @meetSimple;
    
elseif strcmp(mode, 'Punishment')
    % Minimum and maximum strategy numbers (See strategy matrix below)
    minStr = 0;
    maxStr = 3;
    % meet function handle
    meet = @meetPunishment;
    
elseif strcmp(mode, 'Reputation')
    % Minimum and maximum strategy numbers (See strategy matrix below)
    minStr = 0;
    maxStr = 3;
    % meet function handle
    meet = @meetReputation;

else
    fprintf("Invalid mode entered.\n")
    fprintf("Please enter 'Simple', 'Punishment' or 'Reputation'.\n")
    return
end

% Dimentions of lattice
M = 200;
N = 200;

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
    L = randi([minStr maxStr], M, N);
    fprintf('Initial percentage of cooperators for r=%0.2f: %0.2f %% \n', ...
        r, (sum(L(:) == 1) + sum(L(:) == 3)) * 100 / (M * N))
    printPercentages(L)
    
    % Every 100 rounds check the frequencies of the previous checkpoint. If
    % they are the same then skip the rest rounds to save time
    prev0 = 0;prev1 = 0;prev2 = 0;prev3 = 0;
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
                
                % Change strategy if there are any positive differences
                diff(diff < 1e-6) = 0;
                if any(diff ~= 0) && rand() <= 0.9
                    L(i,j) = L(R(rouletteWheelSelection(diff)));
                end
                
            end
        end
        
        % Convergence condition to avoid uneccessary rounds
        epsilon = 0.1;
        if( mod(t, 100) == 0 )
            
            % Find current frequencies
            curr0 = sum(L(:) == 0);
            curr1 = sum(L(:) == 1);
            curr2 = sum(L(:) == 2);
            curr3 = sum(L(:) == 3);
            
            if( abs(curr0 - prev0)/(M*N) < epsilon && ...
                    abs(curr1 - prev1)/(M*N) < epsilon && ...
                    abs(curr2 - prev2)/(M*N) < epsilon && ...
                    abs(curr3 - prev3)/(M*N) < epsilon )
                break
            end
            
            % Update frequencies every 100 rounds
            prev0 = curr0;
            prev1 = curr1;
            prev2 = curr2;
            prev3 = curr3;
            
            pp = (sum(L(:) == 1) + sum(L(:) == 3)) * 100 / (M * N);
            fprintf('Percentage of cooperators at round %d and for r=%0.2f: %f%% \n', t, r, pp)
            printPercentages(L);
        end
        
    end
    frequencies(rr, 1) = sum(L(:) == 0) / (M*N);
    frequencies(rr, 2) = sum(L(:) == 1) / (M*N);
    frequencies(rr, 3) = sum(L(:) == 2) / (M*N);
    frequencies(rr, 4) = sum(L(:) == 3) / (M*N);
end

%% Plot results
figure(1)
plotHex(L)
title('Final grid')

figure(2)
hold on
plot(rArr, frequencies(:, 1), ':')
plot(rArr, frequencies(:, 2), '--')
legend('Defectors', 'Cooperators')

if strcmp(mode, 'Punishment') || strcmp(mode, 'Reputation')
    plot(rArr, frequencies(:, 3), '-.')
    plot(rArr, frequencies(:, 4), '-')
    legend('Antisocial', 'Mild', 'Paradoxical', 'Social')
end

xlabel('multiplication factor, r')
ylabel('frequencies')

fprintf('Final percentage of cooperators: %0.2f %% \n', ...
    (sum(L(:) == 1) + sum(L(:) == 3)) * 100 / (M * N))
