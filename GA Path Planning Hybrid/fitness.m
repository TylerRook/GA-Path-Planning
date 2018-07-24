%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA101
% Project Title: Implementation of Real-Coded Genetic Algorithm in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function [x, z]=fitness(x, table, distTable, coordTable, s, e, map)
    debug = true;

    % For testing:
    distTable;
    coordTable;

    %display("The fitness function started.");
    %x = [s(1) s(2) x e(1) e(2)]; % Add start and end points to the chromosome.

    distance = 0;
    diff = 0;
    totalDistance = 0;
    
    x;
    size(x);
    
    %% Display the individual route
    waypoints = [table(s,1), table(s, 2)];
    
    
    if debug
        hold on
        show(map)
    end
    
    %numWaypoints = size(BestSol.Position)/2;
    %numWaypoints = size(x);
    %for i = 0:(numWaypoints(2)-1)
    
    %% Done displaying the route.
    waypoints = [table(s,1), table(s, 2)];
    pos = s;
    for i = 1:size(x, 2)
        i;
        
        
        % Collect all points that can be moved to.
        sectStart = coordTable(pos, 2);
        sectFinish = coordTable(pos+1, 2);
        sectLength = sectFinish - sectStart - 1;
        
        %pos
        %coordTable(pos, 1)
        %coordTable(pos+1, 1)
        %display('Looking at all connections for');
        pos;
        %display('------------------------------');
        for j = sectStart:sectFinish
            j;
            [distTable(j, 1), distTable(j, 2)];
        end
        %display('------------------------------');
        % Select the individual point you are going to.
        %x(i)
        %sectLength
        %sectStart
        nextPos = sectStart + floor(x(i)*sectLength);
        if nextPos >= sectFinish
            nextPos;
            sectStart;
            sectFinish;
            display("The damn thing didn't do it right");
        end
        pos ;
        [distTable(nextPos, 1), distTable(nextPos, 2)];
        nextPos = distTable(nextPos, 2);
        nextPos;
        
        % Calculate the distance, add to the total.
        firstPoint = [table(pos, 1) table(pos, 2)];
        secondPoint = [table(nextPos, 1) table(nextPos, 2)];
        firstPoint(1);
        firstPoint(2);
        pos;
        [firstPoint(1), firstPoint(2)];
        secondPoint(1);
        secondPoint(2);
        nextPos;
        [secondPoint(1), secondPoint(2)];
        diff = ((firstPoint(1) - secondPoint(1))^2 + (firstPoint(2) - secondPoint(2))^2)^(1/2);
        distance = distance + diff;
        
        waypoints = [waypoints; secondPoint];
        % Update the position.
        pos = nextPos;

        %pause(0.01);
    end
    if debug
        plot(waypoints(:, 1), waypoints(:, 2), 'o-');
        plot(table(e, 1), table(e, 2), 'X');
    end
    
    % Get the distance from the target.
    firstPoint = [table(pos, 1), table(pos, 2)];
    plot(firstPoint(1), firstPoint(2), 'X');
    firstPoint;
    pos;
    secondPoint = [table(e, 1), table(e, 2)];
    plot(secondPoint(1), secondPoint(2), 'P');
    secondPoint;
    errorDistance = ((firstPoint(1) - secondPoint(1))^2 + (firstPoint(2) - secondPoint(2))^2)^(1/2); 
    
    % Check if the last point can make it to the end.
    sectStart = coordTable(e, 2);
    sectFinish = size(distTable, 1);
    
    valid = 1;
    for i = sectStart:(sectFinish)
        connect = [distTable(i, 1), distTable(i, 2)];
        pos;
        connect;
        e;
        
        if connect(2) == pos
            %display("We have a valid solution!!!!");
            valid = 0;
        end
    end    
    connect;
    %pause(30);
    % Return the final fitness value
    z = 10000000*valid + 1000*errorDistance + distance;
    %z = errorDistance;
    
    % Pause for displaying.
    if debug
        pause(0.01);
    end
    
end