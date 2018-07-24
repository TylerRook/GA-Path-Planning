% Build a grid of valid points along the map.

function points = getGrid(img, ratio)
debug = true;

% Get all the edges in the image.
rawImage = rgb2gray(imcomplement(imread(img)));
filtered = edge(rawImage, 'Canny');
map = filtered;

% Prepare the edge map to be used.
imcomplement(map);
[length, width] = size(map);
length = length/ratio - 1;
width = width/ratio - 1;
map = robotics.OccupancyGrid(map, ratio);

% Inflate the map, to keep points away from obstacles.
inflate(map, 1);

% Prepare the grid of points to be displayed.
if debug
    figure;
    hold on
    show(map);
end

% This controls the density and accuracy of the points.
barMove = 4;
checkMove = 0.25;

% Set the initial y value.
y = 1;

% Prepare to get all the points.
points = [];

% Loop scans horizontally, gives points.
while y < length
    % Reset the iterator over the bar.
    x = 1;
    
    % Move the current position.
    beginPos = [x, y];
    
    occupied = getOccupancy(map, [x, y]);
    while x < width
        check = getOccupancy(map, [x, y]);
        if abs(check - occupied) > 0.5 || x + checkMove >= width
            point = [beginPos(1)+abs(beginPos(1) - x)/2,beginPos(2)+abs(beginPos(2) - y)/2];
            if getOccupancy(map, point) < 0.5
                points = [points; point];
            end
            beginPos = [x, y];  
            occupied = check;
        end
        
        % Iterate the scanning of the bar.
        x = x + checkMove;
    end   
    
    % Move the bar.
    y = y + barMove;
end

% Reset the x value.
x = 1;

% Loops through vertically, giving all the points
while x < width 
    % Reset the iterator over the bar.
    y = 1; 
    
    % Move the current position.
    beginPos = [x, y];
    occupied = getOccupancy(map, [x, y]);
    
    while y < length 
        check = getOccupancy(map, [x, y]);
        if abs(check - occupied) > 0.5 || y + checkMove >= length
            point = [beginPos(1)+abs(beginPos(1) - x)/2,beginPos(2)+abs(beginPos(2) - y)/2];
            if getOccupancy(map, point) < 0.5
                points = [points; point];
            end
            beginPos = [x, y];
            occupied = check;
        end
        
        % Iterate the scanning of the bar.
        y = y + checkMove; 
    end
    
    % Move the bar.
    x = x + barMove;
end

% Display all the points created on the grid.
if debug
    points;
    plot(points(:, 1), points(:, 2), 'o');
    zoom on
    pause(0.01);
end