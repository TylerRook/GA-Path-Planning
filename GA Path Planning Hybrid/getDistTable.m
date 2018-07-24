function [distTable, coordTable] = getDistTable(table, map)
    debug = true;

    % Create an empty distTable to be filled.
    distTable = [];
    coordTable = [];
    counter = 1;

    % Inflate the map.
    inflate(map, 1);
    
    % Preparation for displaying.
    if debug
        figure;
        hold on
        show(map);
    end
    
    % Loop through every potential connection and add the valid ones.
    for i = 1:size(table, 1)
        coordTable = [coordTable; [i counter]];
        for j = 1:size(table, 1)
            % Update the table of connections.
            dist = getDistance(i, j, map, table);
            if dist ~= -1
                distTable = [distTable; [i j]];
                counter = counter + 1;
                
                % Display all the valid connections.
                if debug
                    startPoint = [table(i, 1) table(i, 2)];
                    endPoint = [table(j, 1) table(j, 2)];
                    points = [startPoint(1), startPoint(2); endPoint(1), endPoint(2)];
                    plot(points(:, 1), points(:, 2), '-o');
                    pause(0.001);
                end
            end
        end
    end
end
