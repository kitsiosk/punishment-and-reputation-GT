function p = meet(s1,s2,s3,r,c)
% Single round of public goods game with parameters r and c
% s1:        strategy of current player
% s2, s3:    strategy of opponents
%
% where 1 = cooperate
%       0 = defect
    
    p = (s1 + s2 + s3) * r * c / 3 + - s1*c;
    
end