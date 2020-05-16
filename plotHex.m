function plotHex(L)
[M,N] = size(L);

% % Clockwise coordinates of a hexagon. Add one at the end for multiplication
% % below to work properly
% x_hex = [0, 1/sqrt(2), 1/sqrt(2)+1, 2/sqrt(2)+1, 1/sqrt(2)+1, 1/sqrt(2)] + 1;
% y_hex = [1/sqrt(2), 2/sqrt(2), 2/sqrt(2), 1/sqrt(2), 0, 0] + 1;
% length_x = 1/sqrt(2) + 1;
% length_y = 1/sqrt(2);
r = 1/sqrt(2);
y_hex = 1/2 * [0; 1; 2; 2; 1; 0];    % x-coordinates of the vertices
x_hex= 1/2 * [2; 2+r; 2; 1; 1-r; 1]; % y-coordinates of the vertices
length_x = (1+r)/2;
length_y = 1/2;

x = x_hex;
y = y_hex;

x_all = zeros(N^2, 6);
y_all = zeros(N^2, 6);
c = zeros(N^2, 1);
counter = 0;
for i=1:N
    x = (i-1)*length_x + x_hex;
    for j=1:N
       if mod(i+j, 2) == 0
            continue
       end
        index = floor( ((i-1)*N + j)/2 );

        c( index ) = L(i, j);

        y = (j-1)*length_y + y_hex;
        x_all( index, :) = x;
        y_all( index, :) = y;
    end
end

patch(x_all', y_all',  c', 'EdgeColor', 'None')
end