
% input
tmp = importdata('./input/T10',' ',1);
N = str2num(tmp.textdata{1});
Cx = tmp.data(:,1);
Cy = tmp.data(:,2);

% fitness
tmp = importdata('./output/sa_T10_0','',2);

Nave = str2num(tmp.textdata{1});
eBests = tmp.data;

% solution
sol = importdata('./output/sa_T10_best_0');
sol = sol+1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
title('Simulated Annealing: 10 cities')
plot(eBests);


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










