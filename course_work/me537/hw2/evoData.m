function evo = evoData ( file )


% input
%tmp = importdata('./input/T10',' ',1);
tmp = importdata(['./input/' file],' ',1);
evo.nC = str2num(tmp.textdata{1});
evo.Cx = tmp.data(:,1);
evo.Cy = tmp.data(:,2);

% fitness
%tmp = importdata('./output/evo_T10_0','',2);
tmp = importdata(['./output/evo_' file '_0'],'',2);
nAve = str2num(tmp.textdata{1});
eBests = tmp.data;

for i = 0:nAve-1
	tmp = importdata(['./output/evo_' file '_' num2str(i)],'\t',3);
	tests(:,i+1) = tmp.data;
	val = str2num(tmp.textdata{3});

end

evo.ave.data	= mean(tests,2);
evo.ave.e		= std(tests,0,2);

% a solution
% sol = importdata('./output/evo_T10_best_0');
evo.sol = importdata(['./output/evo_' file '_best_0']);
evo.sol = evo.sol+1;

evo.name	= 'Evolutionary';










