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



% Parameters for the Genetic Algorithm
startPoint = [5, 5];
endPoint = [45, 27];
numWaypoints = 16;
%map = 'maze.png';
%ratio = 4;
MaxIt = 30;
nPop = 10;
pc = 0.7;
gamma = 0.4;
pm = 0.3;
mu = 0.5;

save('GAParameters');


% Parameters for the Load Map function
getGridInflation = 1;
map = 'maze.png';
ratio = 4;
barMove = 4;
checkMove = 0.25;
getDistTableInflation = 1;

save('LMParameters');

% Whether it needs to rebuild the map.
buildMap = false;

% Build new map if necessary.
if buildMap
    loadMap(map);
end

% Run the genetic algorithm;
ga;

