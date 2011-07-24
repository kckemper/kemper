function sm = smData ()


% rewards
tmp = importdata('../output/softmax_0','',1);
nAve = str2num(tmp.textdata{1});

for i = 0:nAve-1
	tmp = importdata(['../output/softmax_' num2str(i)],'',1);
	tests(:,i+1) = tmp.data;
end
sm.ave.n	= nAve;
sm.ave.data	= mean(tests,2);
sm.ave.e	= std(tests,0,2);

% average hits
clear tests
for i = 0:nAve-1
	tmp = importdata(['../output/softmax_hits_' num2str(i)],'\t',1);
	tests(:,i+1) = tmp.data(:,2);
end
sm.hits.data	= mean(tests,2);
sm.hits.e		= std(tests,0,2);

sm.name	= 'Softmax';



