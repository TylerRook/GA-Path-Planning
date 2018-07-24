% Clear out everything
clc;
clear;
close all;

% Start Point
s = [1 1];

% End Point
e = [5 5];

% Build all the chromosomes
chrom = [2 2 3 3 4 4];

% Find the fitness
fit = fitness(chrom, s, e);
fit

% Display this chromosome and give the fitness.
chrom = [s chrom e];
figure;
waypoints = [];
numWaypoints = size(chrom)/2;
for i = 0:(numWaypoints(2)-1)
    waypoints = [waypoints; [chrom(1 + i*2) chrom(2 + i*2)]];
end
waypoints
plot(waypoints(:, 1), waypoints(:, 2), 'o-');
grid on;
title(strcat('The fitness of this function is: ', num2str(fit)));