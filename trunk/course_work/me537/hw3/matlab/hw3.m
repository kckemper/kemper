clear all
close all
clc

% Part 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
greedy	= greedyData();
eGreedy	= eGreedyData();
sm		= smData();

plotData(greedy, eGreedy, sm);
save2pdf('../figures/part1.pdf')

plotHits(greedy, eGreedy, sm);
save2pdf('../figures/part1_hits.pdf')

% Part 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gGreedy		= gridGreedyData();
gEGreedy	= gridEGreedyData();
gSm			= gridSoftmaxData();
gQ			= gridQData();

plotData(gGreedy, gEGreedy, gSm, gQ);
save2pdf('../figures/part2.pdf')

