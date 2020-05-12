function hexLatticePlot(L)
% Plot a hexagonal lattice with shading proportional to L values

% Size of lattice
[M,N] = size(L);

% Color of every cell (white for cooperators and black for defectors)
C = repmat(L,1,1,3);

% Coordinates of a hexagon
r = 1/sqrt(2);
xhex = 1/2 * [0; 1; 2; 2; 1; 0];    % x-coordinates of the vertices
yhex= 1/2 * [2; 2+r; 2; 1; 1-r; 1]; % y-coordinates of the vertices

hold on

% Move hexagon to the corresponding positions to form the lattice
for i=1:M    
    for j=1:N
        patch(xhex + mod(i+1,2)/2 + j - 1, ...
              yhex + i*(r+1)/2 - 1, ...
              C(i,j,:),'EdgeColor','None')
    end
end

axis equal
hold off

end