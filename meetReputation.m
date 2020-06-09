function p = meetReputation(s1,s2,s3,r,c,beta,gamma,m)
% Single punishment round of public goods game with parameters r, c,
% beta and gamma
% s1:        strategy of current player
% s2, s3:    strategy of opponents
% m:         probability of a cooperator knowing the strategies of his
%            opponents

% where     0 = defect and not punish
%           1 = cooperate and not punish
%           2 = defect and punish    
%           3 = cooperate and punish


% Extract values, as if there is no punishment
if( s1 == 0 || s1 == 2 )
    v1 = 0;
else
    v1 = 1;
end
if( s2 == 0 || s2 == 2 )
    v2 = 0;
else
    v2 = 1;
end
if( s3 == 0 || s3 == 2 )
    v3 = 0;
else
    v3 = 1;
end

% If s1 is cooperator apply reputation
if( s1 == 1 || s1 == 3 )
    % Generate random number in (0, 1)
    rn = rand();
    if( rn < m )
        % With probability m a cooperator learns about the strategies of his opponents
        if( s2 == 1 && s3 == 1 )
           % If matched with 2 non punishers, then change strategy to defect
           v1 = 0;
        end
    end
end
% If s2 is cooperator apply reputation
if( s2 == 1 || s2 == 3 )
    % Generate random number in (0, 1)
    rn = rand();
    if( rn < m )
        % With probability m a cooperator learns about the strategies of his opponents
        if( s1 == 1 && s3 == 1 )
           % If matched with 2 non punishers, then change strategy to defect
           v2 = 0;
        end
    end
end
% If s3 is cooperator apply reputation
if( s3 == 1 || s3 == 3 )
    % Generate random number in (0, 1)
    rn = rand();
    if( rn < m )
        % With probability m a cooperator learns about the strategies of his opponents
        if( s1 == 1 && s2 == 1 )
           % If matched with 2 non punishers, then change strategy to defect
           v3 = 0;
        end
    end
end

% Payoff of s1 as if there is no punishment
p = (v1 + v2 + v3) * r * c / 3 + - v1*c;

% Calculate number of punisher and defector opponents
s = [s1 s2 s3];
numPunishers = sum( s == 2 ) + sum( s == 3 );
numDefectors = sum( s == 0 ) + sum( s == 2 );

% If I am punisher, pay the punishment fee for each defector
if( s1 == 2 || s1 == 3 )
    p = p - numDefectors*gamma;
end

% If I am defector, pay the punishment fee for each punisher
if( s1 == 0 || s1 == 2 )
    p = p - numPunishers*beta;
end

    
    
end