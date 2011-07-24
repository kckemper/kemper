function sm = gridSoftmaxData ()


% input
%tmp = importdata('../input/T10',' ',1);
%tmp = importdata(['../input/' file],' ',1);
%sa.nC = str2num(tmp.textdata{1});
%sa.Cx = tmp.data(:,1);
%sa.Cy = tmp.data(:,2);

% rewards
tmp = importdata('../output/grid_softmax_0','',1);
nAve = str2num(tmp.textdata{1});

for i = 0:nAve-1
	tmp = importdata(['../output/grid_softmax_' num2str(i)],'',1);
	tests(:,i+1) = tmp.data;
end
sm.ave.n	= nAve;
sm.ave.data	= mean(tests,2);
sm.ave.e	= std(tests,0,2);

sm.name	= 'Softmax';











