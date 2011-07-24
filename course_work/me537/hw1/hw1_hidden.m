%#ok<*ST2NM>
close all
clear all

% Read in the headder from a file
test = importdata('./output/hidden_1_0','\t',3);

nAve = str2num(test.textdata{1});
nHidden = str2num(test.textdata{2});
eta = str2num(test.textdata{3});


% Read in all of the files...
for h = 1:nHidden
	for i = 0:nAve-1
		
		tmp = importdata(['./output/hidden_',num2str(h),'_',num2str(i)],'\t',3);
		hidden(h).tests(:,:,i+1) = tmp.data;
		
	end
end

% Find the averages and STD over the trials...
for h = 1:nHidden
	ave(h).data = mean(hidden(h).tests,3);
	ave(h).e	= std(hidden(h).tests,1,3);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots

colors = brighten(lines(nHidden),0.5); % jet() hsv() lines()
spacing = 20;

for t=2:5
	figure;
	hold on;
	
	
	for h=1:nHidden
		
		p(h) = plot(	ave(h).data(:,1),ave(h).data(:,t), ...
						'Color',colors(h,:), ...
						'LineWidth', 3);

		errorbar(	ave(h).data(1:spacing:end,1),ave(h).data(1:spacing:end,t),ave(h).e(1:spacing:end,t), ...
					'x', ...
					'LineWidth', 2, ...
					'Color',colors(h,:) );
		
		if (h == 1)
			labels = sprintf('Hidden units = %d',h);
		else
			labels = char(labels, sprintf('Hidden units = %d',h));
		end

	end
	
	xlim([0 length(ave(1).data) ]);
	tmp = ylim;
	if tmp(2)>1
		tmp(2) = 1;
	end
	ylim([0 , tmp(2)]);
	
	legend(p,labels,'Location','SouthEast');


	if (t == 2)
		title(sprintf('\\DeltaHidden\nTraining Data: \\eta=%1.3f',eta));
	else
		title(sprintf('\\DeltaHidden\nTest %d: \\eta=%1.3f',t-2,eta));
	end
	xlabel('Epoch');
	ylabel('Correct Classification %');

end



