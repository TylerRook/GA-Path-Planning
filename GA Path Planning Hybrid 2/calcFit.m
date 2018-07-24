function [diff, y, collisions] = calcFit(startPoint, endPoint, x, map, k, ending, ratio, table)
    if startPoint(1) < endPoint(1)
        firstX = startPoint(1);
        firstY = startPoint(2);
        secondX = endPoint(1);
        secondY = endPoint(2);
    else
        firstX = endPoint(1);
        firstY = endPoint(2);
        secondX = startPoint(1);
        secondY = startPoint(2);
    end
    
    
    mu=0.95;         % Mutation Rate
    VarMin= 1;         % Lower Bound of Variables
    table;
    VarMax= size(table, 1);
    
    diff = ((secondX - firstX)^2 + (secondY - firstY)^2)^(1/2);
    collisions = 0;
   
    
    % Collision detection.
    dx = secondX - firstX;
    dy = secondY - firstY;
    h = (dx^2 + dy^2)^(1/2);
    theta = atan(dy/dx);
    % Account for angles to the left.
    %if dx < 0
    %    theta = theta + 1;
    %end
    iterator = 0.25;
    n = 0;
    
    threshold = 0.1;
    tempX = 0;
    tempY = 0;
    prevCollision = false;
    while n < h
        tempX = firstX + n*cos(theta);
        tempY = firstY + n*sin(theta);
        
        obstacle = getOccupancy(map, [tempX, tempY]);
        
        if (( (n*cos(theta))^2 + (n*sin(theta))^2 )^(1/2)) > h
            display("Had to hit the breaks");
            break
        end
        
        if obstacle > threshold
            if ~prevCollision
                collisions = collisions + 1;
                prevCollision = true;
            end
            x = Mutate(x, mu, VarMin, VarMax, k);

        else
            prevCollision = false;
        end
        
        n = n + iterator;
    end    
     collisions;
    
        
    
    
    y = x;
end