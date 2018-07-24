% Function to give a true or false result for collision detection.

function collision=detectCollisions(map, s, e)
    [endPoints, midPoints] = raycast(map, s, e);
    
    startPoint = getOccupancy(map, s);
    endPoint = getOccupancy(map, e);
    midCollision = false;
    
    for i = 1:size(midpoints)
        if getOccupancy(map, midPoints(i))
            midCollision = true;
        end
    end
    
    collision = startPoint || endPoint || midCollision;
end