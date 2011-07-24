close all
clear all
addpath ./mpgwrite/;

inputDir = './inputs/dataset1/image';

for k = 0:850
	str = sprintf('%s%010d.jpg',inputDir,k);
	frame = imread(str);
	
	image(frame);
	axis off
	F(k+1) = getFrame;
	
end

mpgwrite(F, 'jet', 'out.avi');


