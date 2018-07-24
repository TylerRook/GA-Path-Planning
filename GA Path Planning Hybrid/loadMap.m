% This function processes the image, building a map and a grid
% of points, along with all valid connections.

function loadMap(mapImg)
% Take an image, build an occupancy grid.
tic;
img = imread(mapImg);
img = img(:,:,2) < 128;
map = im2bw(img);
%map = imcomplement(map);
ratio = 4;
map = robotics.OccupancyGrid(map, ratio); 
time = toc;
display(strcat('The time to build the map is _', num2str(time), '_ seconds'));

% Create a grid of points along the map.
tic;
table = getGrid(mapImg, ratio);
time = toc;
display(strcat('The time to build the grid of points is _', num2str(time), '_ seconds'));                 

% Find all connections between points in the table.
tic;
[distTable, coordTable] = getDistTable(table, map);
time = toc;
display(strcat('The time to gather all the connections is _', num2str(time), '_ seconds'));
    
% Save all the data.
save('TableInfo');






%% Starting displaying for debugging.
%mapImg = 'maze.png';
%map = im2bw(imread(mapImg));
%map = imcomplement(map);
%ratio = 4;
%map = robotics.OccupancyGrid(map, ratio);
%
%figure;
%hold on
%show(map);
%for i = 1:size(distTable, 1)
%
%    startPoint = [table(distTable(i, 1), 1) table(distTable(i, 1), 2)];
%    endPoint = [table(distTable(i, 2), 1) table(distTable(i, 2), 2)];
%    
%    points = [startPoint(1), startPoint(2); endPoint(1), endPoint(2)];
%    plot(points(:, 1), points(:, 2), '-o');
%    pause(0.01);
%end
%% End displaying for debugging.


end