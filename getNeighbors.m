function R = getNeighbors(i,j,M,N)

% Find neighbors for general case
if i ~= 1 && i ~= M && j ~= 1 && j ~= N
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
% Find corner cases
elseif i == 1
    if j == 1
        R = [i,   j+1;
             i+1, j];
    elseif j == N
        if mod(j,2) == 0
            R = [i+1, j;
                 i+1, j-1;
                 i,   j-1];
        else
            R = [i+1, j;
                 i,   j-1];
        end
    else
        if mod(j,2) == 0
            R = [i,   j+1;
                 i+1, j+1;
                 i+1, j;
                 i+1, j-1;
                 i,   j-1];
        else
            R = [i,   j+1;
                 i+1, j;
                 i,   j-1];
        end
    end
elseif i == M
    if j == 1
        R = [i-1, j+1;
             i,   j+1;
             i-1, j];
    elseif j == N
        if mod(j,2) == 0
            R = [i,   j-1;
                 i-1, j];
        else
            R = [i,   j-1;
                 i-1, j-1;
                 i-1, j];
        end
    else
        if mod(j,2) == 0
            R = [i,   j+1;
                 i,   j-1;
                 i-1, j];
        else
            R = [i-1, j+1;
                 i,   j+1;
                 i,   j-1;
                 i-1, j-1;
                 i-1, j];
        end
    end
else
    if j == 1
        R = [i-1, j+1;
             i,   j+1;
             i+1, j;
             i-1, j];
    elseif j == N
        if mod(j,2) == 0
            R = [i+1, j;
                 i+1, j-1;
                 i,   j-1;
                 i-1, j];
        else
            R = [i+1, j;
                 i,   j-1;
                 i-1, j-1;
                 i-1, j];
        end
    end
end

% Convert to column major indexing
R =  R(:,1) + (R(:,2) - 1) * M;

end