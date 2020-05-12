%% INITIALIZATION
clear
close all

% Dimentions of lattice
M = 100;
N = 100;

% Number of rounds
T = 100;

% Investment multiplication factor
r = 1.7;
% Cost of cooperation
c = 1;

% Strategy matrix (randomly generated)
% 1 for cooperators
% 0 for defectors
L = unidrnd(2,M,N) - 1;

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
                P(i,j) = P(i,j) + meet(L(i,j),L(R(k)),L(R(k+1)),r,c);
            end
            
            % If there are more than two neighbors,
            % then meet with the last and first neighbor
            % and find the mean score
            if lR > 2
                P(i,j) = P(i,j) + meet(L(i,j),L(R(lR)),L(R(1)),r,c);
                P(i,j) = P(i,j) / lR;
            end
            
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
            
            % Exclude neighbors with lower or equal scores from imitation
            negative_diff = diff < 1e-6;
            R(negative_diff) = [];
            diff(negative_diff) = [];
            
            if ~isempty(diff)
                L(i,j) = L(R(rouletteWheelSelection(diff)));
            end
            
        end
    end
    
end

%% Plot results
figure
hexLatticePlot(L)

disp(['Percentage of cooperators: ', num2str(sum(L(:)) * 100 / (M * N)), ' %'])