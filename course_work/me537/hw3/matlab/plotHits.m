function plotHits( res1, res2, res3 )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
title(['Average Slot Pulls: ' num2str(res1.ave.n) ' trials'])

colors = brighten(lines(3),0.5); % jet() hsv() lines()

pack.data	= [res1.hits.data	res2.hits.data	res3.hits.data];
pack.e		= [res1.hits.e		res2.hits.e		res3.hits.e];

p1 = barweb(pack.data, pack.e);

Colormap(colors);


%xlim([0,length(results2.ave.data)+1]);

legend(p1.bars, res1.name, res2.name, res3.name);

xlabel('Slot index');
ylabel('# of pulls');