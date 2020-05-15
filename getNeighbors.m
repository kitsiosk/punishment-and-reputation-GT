function R = getNeighbors(i,j,M,N)

% Find neighbors for general case
if mod(j,2) == 0
    R = [i,   j+1;
         i+1, j+1;
         i+1, j;
         i+1, j-1;
         i,   j-1;
         i-1, j];
else
    R = [i-1, j+1;
         i,   j+1;
         i+1, j;
         i,   j-1;
         i-1, j-1;
         i-1, j];
end

% Exclude corner cases
R(any(R == 0,2),:) = [];
R(R(:,1) == M+1,:) = [];
R(R(:,2) == N+1,:) = [];

% Convert to column major indexing
R =  R(:,1) + (R(:,2) - 1) * M;

end