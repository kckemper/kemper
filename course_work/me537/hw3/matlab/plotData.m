function plotData( res1, res2, res3, res4 )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
title(['Total Reward: ' num2str(res1.ave.n) ' trials'])

spacing = length(res1.ave.data)/20;
colors = brighten(lines(4),0.5); % jet() hsv() lines()

% first set of results
p1 = plot(	res1.ave.data, ...
			'LineWidth', 3, ...
			'Color',colors(1,:) );
errorbar(1:spacing:length(res1.ave.data), res1.ave.data(1:spacing:end), res1.ave.e(1:spacing:end), ...
			'x', ...
			'LineWidth', 2, ...
			'Color',colors(1,:) );

% second set of results
p2 = plot(	res2.ave.data, ...
			'LineWidth', 3, ...
			'Color',colors(2,:) );
errorbar(1:spacing:length(res2.ave.data), res2.ave.data(1:spacing:end), res2.ave.e(1:spacing:end), ...
			'x', ...
			'LineWidth', 2, ...
			'Color',colors(2,:) );
		
% third set of results
p3 = plot(	res3.ave.data, ...
			'LineWidth', 3, ...
			'Color',colors(3,:) );
errorbar(1:spacing:length(res3.ave.data), res3.ave.data(1:spacing:end), res3.ave.e(1:spacing:end), ...
			'x', ...
			'LineWidth', 2, ...
			'Color',colors(3,:) );

if ( exist('res4') ~= 0)
% fourth set of results
	p4 = plot(	res4.ave.data, ...
				'LineWidth', 3, ...
				'Color',colors(4,:) );
	errorbar(1:spacing:length(res4.ave.data), res4.ave.data(1:spacing:end), res4.ave.e(1:spacing:end), ...
				'x', ...
				'LineWidth', 2, ...
				'Color',colors(4,:) );
			
	legend([p1,p2,p3,p4], res1.name, res2.name, res3.name, res4.name);
	xlabel('Trial');
	ylabel('n-steps to door');
else
	legend([p1,p2,p3], res1.name, res2.name, res3.name);
	xlabel('Step');
	ylabel('Reward');
end

xlim([0,length(res2.ave.data)+1]);


