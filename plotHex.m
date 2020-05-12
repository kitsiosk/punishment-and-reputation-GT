N = 600;
% Size of lattice
[M,N] = size(L);

% Clockwise coordinates of a hexagon. Add one at the end for multiplication
% below to work properly
x_hex = [0, 1/sqrt(2), 1/sqrt(2)+1, 2/sqrt(2)+1, 1/sqrt(2)+1, 1/sqrt(2)] + 1;
y_hex = [1/sqrt(2), 2/sqrt(2), 2/sqrt(2), 1/sqrt(2), 0, 0] + 1;

x = x_hex;
y = y_hex;

tic;

x_all = zeros(N^2/2, 6);
y_all = zeros(N^2/2, 6);
c = zeros(N^2/2, 1);
for i=1:N
    x = (i-1)*(1/sqrt(2) + 1) + x_hex;
    for j=1:N
        if mod(i+j, 2) == 0
            continue
        end
        y = (j-1)*1/sqrt(2) + y_hex;
%         patch(x, y, 'red')
        index = floor( ((i-1)*N + j)/2 );
        x_all( index, :) = x;
        y_all( index, :) = y;
        c( index ) = L(i, j);
    end
end

toc;

patch(x_all', y_all', c, 'EdgeColor', 'None')