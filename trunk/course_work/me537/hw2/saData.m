function sa = saData ( file )


% input
%tmp = importdata('./input/T10',' ',1);
tmp = importdata(['./input/' file],' ',1);
sa.nC = str2num(tmp.textdata{1});
sa.Cx = tmp.data(:,1);
sa.Cy = tmp.data(:,2);

% fitness
%tmp = importdata('./output/sa_T10_0','',2);
tmp = importdata(['./output/sa_' file '_0'],'',2);
nAve = str2num(tmp.textdata{1});
eBests = tmp.data;

for i = 0:nAve-1
	tmp = importdata(['./output/sa_' file '_' num2str(i)],'\t',3);
	tests(:,i+1) = tmp.data;
	val = str2num(tmp.textdata{3});

end

sa.ave.data	= mean(tests,2);
sa.ave.e		= std(tests,0,2);

% a solution
% sol = importdata('./output/evo_T10_best_0');
sa.sol = importdata(['./output/sa_' file '_best_0']);
sa.sol = sa.sol+1;

sa.name	= 'Simulated Annealing';











