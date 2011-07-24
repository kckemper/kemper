function plotData( results1 , results2 )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
title(['Total Path Distance: ' num2str(results1.nC) ' cities'])

spacing = length(results1.ave.data)/20;
colors = brighten(lines(2),0.5); % jet() hsv() lines()

% first set of results
p1 = plot(	results1.ave.data, ...
			'LineWidth', 3, ...
			'Color',colors(1,:) );
errorbar(1:spacing:length(results1.ave.data), results1.ave.data(1:spacing:end), results1.ave.e(1:spacing:end), ...
			'x', ...
			'LineWidth', 2, ...
			'Color',colors(1,:) );

% second set of results
p2 = plot(	results2.ave.data, ...
			'LineWidth', 3, ...
			'Color',colors(2,:) );
errorbar(1:spacing:length(results2.ave.data), results2.ave.data(1:spacing:end), results2.ave.e(1:spacing:end), ...
			'x', ...
			'LineWidth', 2, ...
			'Color',colors(2,:) );
		
		
xlim([0,length(results2.ave.data)+1]);

legend([p1,p2],results1.name,results2.name);

xlabel('Step');
ylabel('Distance (light years)');