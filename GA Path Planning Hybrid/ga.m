
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

clc;
clear;
close all;

%% Problem Definition
startPoint = [5, 5];
endPoint = [45, 27];
numWaypoints = 16;


frame = 1; % Going to be used to record all the frames of learning.

CostFunction=@(x, table, distTable, coordTable, s, e, map) fitness(x, table, distTable, coordTable, s, e, map);     % Cost Function

nVar=numWaypoints;             % Number of Decision Variables 

VarSize=[1 nVar];   % Decision Variables Matrix Size


load('TableInfo');
% Give the table start and end points.
table = [table; startPoint; endPoint];
size(table, 1)


s = size(table, 1) - 1;
e = size(table, 1);

% Give the distTabe start and end points.
% Give the coordTable start and end points.
counter = size(distTable, 1);
startCounter = counter + 1;
for i = 1:size(table)
    distStart = getDistance(s, i, map, table);
    if distStart ~= -1
        distTable = [distTable; [s, i]];
        counter = counter + 1;
    end
end
coordTable = [coordTable; [s startCounter]];

counter = counter + 1;
for i = 1:size(table)
    distStart = getDistance(e, i, map, table);
    if distStart ~= -1
        distTable = [distTable; [e, i]];
        %counter = counter + 1;
    end
end
coordTable = [coordTable; [e counter]];

%size(table)
%for i = 1:size(table, 1)
%    i
%    [table(i, 1), table(i, 2)]
%end


%[table(size(table, 1), 1), table(size(table, 1), 2)]

%% Starting displaying for debugging.
mapImg = 'maze.png';
map = im2bw(imread(mapImg));
map = imcomplement(map);
ratio = 4;
map = robotics.OccupancyGrid(map, ratio);

figure;
hold on
show(map);

%for i = 1:(size(coordTable, 1) - 1)
%    display("**************************************")
%    display(strcat("The start of coordinate: _", num2str(i)))
%    display("**************************************")
%    
%    sectStart = coordTable(i, 2);
%    sectFinish = coordTable(i+1, 2);
%    sectLength = sectFinish - sectStart - 1;
%    
    % Use the coordTable to loop through the distTable.
%    for j = sectStart:(sectFinish - 1)
%        display(strcat("first point: _", num2str(distTable(j, 1)), "__second point: _", num2str(distTable(j, 2))));
%    end
%end

%pause(300);
%for i = 1:size(distTable, 1)
%
%    startPoint = [table(distTable(i, 1), 1) table(distTable(i, 1), 2)];
%    endPoint = [table(distTable(i, 2), 1) table(distTable(i, 2), 2)];
%    
%    points = [startPoint(1), startPoint(2); endPoint(1), endPoint(2)];
%    plot(points(:, 1), points(:, 2), '-o');
%    pause(0.01);
%end

%for i = 1:(size(coordTable, 1) - 1)
    % Get the gap for the coordTable.
%    sectStart = coordTable(i, 2);
%    sectFinish = coordTable(i+1, 2);
%    sectLength = sectFinish - sectStart - 1;
%    
    % Use the coordTable to loop through the distTable.
%    for j = sectStart:(sectFinish - 1)
%        startPoint = [table(distTable(j, 1), 1) table(distTable(j, 1), 2)];
%        lastPoint = [table(distTable(j, 2), 1) table(distTable(j, 2), 2)];
%    
%        points = [startPoint(1), startPoint(2); lastPoint(1), lastPoint(2)];
%        plot(points(:, 1), points(:, 2), '-o');
%        pause(0.01);
%    end
%end
%pause(30);

%% End displaying for debugging.

%% This begins the building of the tables.
%table = [];
%img = 'maze.png';
%map = im2bw(imread('maze.png'));
%map = imcomplement(map);
%ratio = 4;
%map = robotics.OccupancyGrid(map, ratio); 
% -----------------------------------------------
% Here we need to load the table.
% table = getGrid(img, ratio, startPoint, endPoint);
%inflate(map, 5);                   
                   

% -----------------------------------------------
% Here we need to load the distTable and coordTable.
%[distTable, coordTable] = getDistTable(table, map);
%display("Finished building the distance table.");

%% This is the end of actually building the map.

figure;
VarMin= 0;         % Lower Bound of Variables
VarMax= 1;
% Upper Bound of Variables
                   % These bounds need to be changed to account for the
                   % entire grid.
                   
%figure; % Set up for displaying real-time learning.
%% GA Parameters

MaxIt=30;     % Maximum Number of Iterations

nPop=10;      % Population Size

pc=0.7;                 % Crossover Percentage
nc=2*round(pc*nPop/2);  % Number of Offsprings (also Parnets)
gamma=0.4;              % Extra Range Factor for Crossover

pm=0.3;                 % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants
mu=0.5;         % Mutation Rate

ANSWER=questdlg('Choose selection method:','Genetic Algorith',...
    'Roulette Wheel','Tournament','Random','Roulette Wheel');

UseRouletteWheelSelection=strcmp(ANSWER,'Roulette Wheel');
UseTournamentSelection=strcmp(ANSWER,'Tournament');
UseRandomSelection=strcmp(ANSWER,'Random');

if UseRouletteWheelSelection
    beta=8; % Selection Pressure
end

if UseTournamentSelection
    TournamentSize=3;   % Tournamnet Size
end

pause(0.01); % Due to a bug in older versions of MATLAB

%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];

pop=repmat(empty_individual,nPop,1);

for i=1:nPop
    
    % Initialize Position
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    % Evaluation
    [pop(i).Position, pop(i).Cost]=CostFunction(pop(i).Position, table, distTable, coordTable, s, e, map);
    %[throwaway, pop(i).Cost]=CostFunction(pop(i).Position, startPoint, endPoint, map);
    
end

% Sort Population
Costs=[pop.Cost];
[Costs, SortOrder]=sort(Costs);
pop=pop(SortOrder);

% Store Best Solution
BestSol=pop(1);

% Prepare this for recording
frame = 1;

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Store Cost
WorstCost=pop(end).Cost;

%% Main Loop

for it=1:MaxIt
    
    % Calculate Selection Probabilities
    if UseRouletteWheelSelection
        P=exp(-beta*Costs/WorstCost);
        P=P/sum(P);
    end
    
    % Crossover
    popc=repmat(empty_individual,nc/2,2);
    for k=1:nc/2
        
        % Select Parents Indices
        if UseRouletteWheelSelection
            i1=RouletteWheelSelection(P);
            i2=RouletteWheelSelection(P);
        end
        if UseTournamentSelection
            i1=TournamentSelection(pop,TournamentSize);
            i2=TournamentSelection(pop,TournamentSize);
        end
        if UseRandomSelection
            i1=randi([1 nPop]);
            i2=randi([1 nPop]);
        end

        % Select Parents
        p1=pop(i1);
        p2=pop(i2);
        
        % Apply Crossover
        [popc(k,1).Position, popc(k,2).Position]=...
            Crossover(p1.Position,p2.Position,gamma,VarMin,VarMax);
        
        % Evaluate Offsprings
        [popc(k,1).Position, popc(k,1).Cost]=CostFunction(popc(k,1).Position, table, distTable, coordTable, s, e, map);
        [popc(k,2).Position, popc(k,2).Cost]=CostFunction(popc(k,2).Position, table, distTable, coordTable, s, e, map);
        
        %[throwaway, popc(k,1).Cost]=CostFunction(popc(k,1).Position, startPoint, endPoint, map);
        %[throwaway, popc(k,2).Cost]=CostFunction(popc(k,2).Position, startPoint, endPoint, map);
        
    end
    popc=popc(:);
    
    % Mutation
    popm=repmat(empty_individual,nm,1);
    for k=1:nm
        
        % Select Parent
        i=randi([1 nPop]);
        p=pop(i);
        
        % Apply Mutation
        popm(k).Position=Mutate(p.Position,mu,VarMin,VarMax, -1);
        
        % Evaluate Mutant
        [throwaway, popm(k).Cost]=CostFunction(popm(k).Position, table, distTable, coordTable, s, e, map);
        
    end
    
    
    % Create Merged Population
    pop=[pop
         popc
         popm]; %#ok
     
   
     
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
    
    
    % Update Worst Cost
    WorstCost=max(WorstCost,pop(end).Cost);
    
    % Truncation
    pop=pop(1:nPop);
    Costs=Costs(1:nPop);
    
    % Store Best Solution Ever Found
    BestSol=pop(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ':Best Cost = ' num2str(BestCost(it))]);
    
    %Display best chromosome of this iteration.
    % Put the results into a 2d array for easier graphing.
    map = im2bw(imread('maze.png'));
    map = imcomplement(map);
    map = robotics.OccupancyGrid(map, ratio);
    hold on
    show(map)
    waypoints = [table(s,1), table(s, 2)];
    
    %% From here on out, this is what prints out the results.
    
    %numWaypoints = size(BestSol.Position)/2;
    numWaypoints = size(BestSol.Position);
    %for i = 0:(numWaypoints(2)-1)
    pos = s;
    positions = [pos];
    for i = 1:numWaypoints(2)
        % Here we need to convert everything into waypoints.
        
        % Collect all points that can be moved to.
        sectStart = coordTable(pos, 2);
        sectFinish = coordTable(pos+1, 2);
        sectLength = sectFinish - sectStart - 1;
        
        % Select the individual point you are going to.
        nextPos = sectStart + floor(BestSol.Position(i)*sectLength);
        nextPos = distTable(nextPos, 2);
        secondPoint = [table(nextPos, 1) table(nextPos, 2)];
        
        waypoints = [waypoints; secondPoint];
        pos = nextPos;
        positions = [positions; pos];
        
    end
    
    if BestSol.Cost < 10000000
        waypoints = [waypoints; endPoint];
        positions = [positions; e];
    end
    
    pos;
    plot(table(pos, 1), table(pos, 2), 'P');
    plot(waypoints(:, 1), waypoints(:, 2), 'o-');
    plot(table(e, 1), table(e, 2), 'X');
    grid on;
    pause(3)
    framesPerIter = 3;
    count = 0;
    while count < framesPerIter
        
        M(frame) = getframe;
    	frame = frame + 1;
        count = count + 1;
    end
    
    
    
    if BestSol.Cost < 10000000
        %break
    end
end

pause(2);

%% Results


%Play back the movie.
%figure;
%movie(M, 5);
m = VideoWriter('Test7.avi');
open(m);
writeVideo(m, M);
close(m);

% Clean up the results.
i = 1;
newPositions = [positions(1)];
coordTable




while i < size(positions, 1)
    
    next = i + 1;
    j = next;
    while j < size(positions, 1)  
        
        
        positions(i)
        sectStart = coordTable(positions(i), 2)
        sectFinish = coordTable(positions(i)+1, 2)
        j;
        for k = sectStart:(sectFinish)
            connect = [distTable(k, 1), distTable(k, 2)];
            connect;
            
            if connect(2) == positions(j)
                %display("Found a connection");
                next = j;
            end
        end  
        
        secStart = coordTable(e, 2);
        sectFinish = size(distTable, 1);
        for k = sectStart:sectFinish
            connect = [distTable(k, 1), distTable(k, 2)];
            if connect(2) == positions(j)
                %display("Found last connection");
                %next = j;
            end
        end
        
        
        j = j + 1;
        
    end
    newPositions = [newPositions; positions(next)];
    i = next;
end

positions;
newPositions;

hold on
show(map)

size(positions);
size(newPositions);

waypoints = [];
for i = 1:size(newPositions)
    point = [table(newPositions(i), 1), table(newPositions(i), 2)];
    waypoints = [waypoints; point];
end

plot(waypoints(:, 1), waypoints(:, 2), '-o');

pause(2);

figure;
%semilogy(BestCost,'LineWidth',2);
plot(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Cost');
grid on;


%while i < size(positions, 1)
%    i
%    next = i + 1;
%    j = i;
%    while j < size(positions, 1)  
%        j
%        i
%        positions(i)
%        sectStart = coordTable(positions(i), 2);
%        sectFinish = size(distTable, 1);
%        for k = sectStart:(sectFinish)
%            connect = [distTable(k, 1), distTable(k, 2)];
%            
%            if connect(2) == positions(j)
%                next = j;
%            end
%        end  
%        j = j + 1;
%        
%    end
%    newPositions = [newPositions; next];
%    i = next;
%end
%
%positions
%newPositions