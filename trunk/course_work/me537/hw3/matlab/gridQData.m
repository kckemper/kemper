function Q = gridQData ()


% input
%tmp = importdata('../input/T10',' ',1);
%tmp = importdata(['../input/' file],' ',1);
%sa.nC = str2num(tmp.textdata{1});
%sa.Cx = tmp.data(:,1);
%sa.Cy = tmp.data(:,2);

% rewards
tmp = importdata('../output/grid_Q_0','',1);
nAve = str2num(tmp.textdata{1});

for i = 0:nAve-1
	tmp = importdata(['../output/grid_Q_' num2str(i)],'',1);
	tests(:,i+1) = tmp.data;
end
Q.ave.n	= nAve;
Q.ave.data	= mean(tests,2);
Q.ave.e	= std(tests,0,2);

Q.name	= 'Q-learner';











