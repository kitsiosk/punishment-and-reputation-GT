function plotHex(L)
[M,N] = size(L);

% Clockwise coordinates of a hexagon.
r = sqrt(3);
x_hex = [3/2 2 3/2 1/2 0 1/2];      % x-coordinates of the vertices
y_hex = [r r/2 0 0 r/2 r];          % y-coordinates of the vertices

% Distances between heaxagons
dist_x = 3/2;
dist_y = r;

x_all = zeros(M*N, 6);
y_all = zeros(M*N, 6);
c = zeros(M*N, 1);

for i=1:M
    for j=1:N
        index = i*M + j;
        
        c( index ) = L(i, j);
        x_all( index, :) = x_hex + (j-1) * dist_x;
        y_all( index, :) = y_hex + (mod(j+1,2)/2+i-1) * dist_y;
    end
end

patch(x_all', y_all',  c', 'EdgeColor', 'None')

end