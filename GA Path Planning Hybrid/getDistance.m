function diff = getDistance(startPoint, endPoint, map, table)
    % Ensure the check is always moving to the right.
    if table(startPoint, 1) < table(endPoint, 1)
        firstX = table(startPoint, 1);
        firstY = table(startPoint, 2);
        secondX = table(endPoint, 1);
        secondY = table(endPoint, 2);
    else
        firstX = table(endPoint, 1);
        firstY = table(endPoint, 2);
        secondX = table(startPoint, 1);
        secondY = table(startPoint, 2);
    end
    
    % -------------------
    % Calculate distance.
    % -------------------
    diff = ((secondX - firstX)^2 + (secondY - firstY)^2)^(1/2);
    collisions = 0;
    dx = secondX - firstX;
    dy = secondY - firstY;
    h = (dx^2 + dy^2)^(1/2);
    theta = atan(dy/dx);
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
        
        if obstacle > threshold
            if ~prevCollision
                collisions = collisions + 1;
                prevCollision = true;
                break
            end

        else
            prevCollision = false;
        end
        
        n = n + iterator;
    end
    
    % Prepare the results.
    if collisions > 0
        diff = -1;
    end
end