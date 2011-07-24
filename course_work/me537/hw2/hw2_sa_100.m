
% input
tmp = importdata('./input/T100',' ',1);
N = str2num(tmp.textdata{1});
Cx = tmp.data(:,1);
Cy = tmp.data(:,2);

% fitness
tmp = importdata('./output/sa_T100_0','',2);

nAve = str2num(tmp.textdata{1});
eBests = tmp.data;

for i = 0:nAve-1
	tmp = importdata(['./output/sa_T100_',num2str(i)],'\t',3);
	tests(:,i+1) = tmp.data;
	val = str2num(tmp.textdata{3});

end

ave.data	= mean(tests,2);
ave.e		= std(tests,0,2);

% a solution
sol = importdata('./output/sa_T100_best_0');
sol = sol+1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
title('Simulated Annealing: 100 cities')
spacing = 50;

plot(ave.data, ...
				'LineWidth', 3);


errorbar(1:spacing:length(ave.data), ave.data(1:spacing:end), ave.e(1:spacing:end), ...
			'x', ...
			'LineWidth', 2);
		
xlim([0,length(ave.data)]);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
title('Path');
plot(Cx,Cy,' .r','markersize',20);

for i =1:length(sol)-1
	line( [Cx(sol(i)) Cx(sol(i+1))],[Cy(sol(i)) Cy(sol(i+1))] )
	text( Cx(sol(i)), Cy(sol(i))-40, num2str(i-1),'BackgroundColor','w');
	
end

text( Cx(sol(i+1)), Cy(sol(i+1))-40, num2str(i),'BackgroundColor','w');
line( [Cx(sol(i+1)) Cx(sol(1))],[Cy(sol(i+1)) Cy(sol(1))] )










