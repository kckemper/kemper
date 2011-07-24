
close all
clear all

tmp = importdata('./output/eta_1_0','\t',3);

nAve = str2num(tmp.textdata{1});
nEta = str2num(tmp.textdata{2});


for x = 1:nEta
	for i = 0:nAve-1
		
		tmp = importdata(['./output/eta_',num2str(x-1),'_',num2str(i)],'\t',3);
		eta(x).tests(:,:,i+1) = tmp.data;
		eta(x).val = str2num(tmp.textdata{3});
		
	end
end

for x = 1:nEta
	ave(x).data = mean(eta(x).tests,3);
	ave(x).e	= std(eta(x).tests,1,3);
end


colors = brighten(lines(nEta),0.5); % jet() hsv() lines()
spacing = 20;

for t=2:5
	figure;
	hold on;
	
	for x=1:nEta
		p(x) = plot(	ave(x).data(:,1),ave(x).data(:,t), ...
						'Color',colors(x,:), ...
						'LineWidth', 3);

		errorbar(	ave(x).data(1:spacing:end,1),ave(x).data(1:spacing:end,t),ave(x).e(1:spacing:end,t), ...
					'x', ...
					'LineWidth', 2, ...
					'Color',colors(x,:) );
			
		labels(x,:) = sprintf('%1.3f',eta(x).val);

	end
	
	xlim([0 length(ave(1).data) ]);
	tmp = ylim;
	if tmp(2)>1
		tmp(2) = 1;
	end
	ylim([0 , tmp(2)]);
	
	legend(p,labels,'Location','SouthEast');


	if (t == 2)
		title(sprintf('\\Delta\\eta\nTraining Data: hidden=4'));
	else
		title(sprintf('\\Delta\\eta\nTest %d: hidden=4',t-2));
	end
	xlabel('Epoch');
	ylabel('Correct Classification %');

end



