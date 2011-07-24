function [] = prettyPlot( x, y , title_str, x_str, y_str)
%PRETTYPLOT Plot function to make sure all graphs match and look good for
%the paper
%   x	: the x scale
%	y	: the set of data to plot, must be the same length as x

	n = length(y(1,:));

	colors = brighten(lines(n),0.5); % jet() hsv() lines()

	hold on
	title(title_str)
	for i = 1:n
		plot(	x,	y(:,i), ...
				'LineWidth', 3, ...
				'Color',colors(1,:) );
	end

	xlabel(x_str);
	ylabel(y_str);

end

