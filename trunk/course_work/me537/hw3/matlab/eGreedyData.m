function greedy = eGreedyData ()


% rewards
tmp = importdata('../output/e_greedy_0','',1);
nAve = str2num(tmp.textdata{1});

for i = 0:nAve-1
	tmp = importdata(['../output/e_greedy_' num2str(i)],'',1);
	tests(:,i+1) = tmp.data;
end
greedy.ave.n	= nAve;
greedy.ave.data	= mean(tests,2);
greedy.ave.e	= std(tests,0,2);

% average hits
clear tests
for i = 0:nAve-1
	tmp = importdata(['../output/e_greedy_hits_' num2str(i)],'\t',1);
	tests(:,i+1) = tmp.data(:,2);
end
greedy.hits.data	= mean(tests,2);
greedy.hits.e		= std(tests,0,2);

greedy.name	= '\epsilon-Greedy';











