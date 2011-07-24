close all
clear

%outs = importdata('./output.txt','\t',0);
%ep = outs(:,1);

for i = 0:9
	tmp = importdata(['./outputs/output_' num2str(i) '.txt'],'\t',0);
	ep = tmp(:,1);
	tests.g1(:,i+1) = tmp(:,2)/50;
	tests.g2(:,i+1) = tmp(:,3)/50;
	tests.g3(:,i+1) = tmp(:,4)/50;
	tests.g4(:,i+1) = tmp(:,5)/50;
	tests.g5(:,i+1) = tmp(:,6)/50;
	tests.g6(:,i+1) = tmp(:,7)/50;
	tests.g7(:,i+1) = tmp(:,8)/50;
	tests.g8(:,i+1) = tmp(:,9)/50;
	
end
outs.nAve	= 10;

outs.data(:,1)	= mean(tests.g1,2);
outs.e(:,1)		= std( tests.g1,0,2);
outs.data(:,2)	= mean(tests.g2,2);
outs.e(:,2)		= std( tests.g2,0,2);
outs.data(:,3)	= mean(tests.g3,2);
outs.e(:,3)		= std( tests.g3,0,2);
outs.data(:,4)	= mean(tests.g4,2);
outs.e(:,4)		= std( tests.g4,0,2);
outs.data(:,5)	= mean(tests.g5,2);
outs.e(:,5)		= std( tests.g5,0,2);
outs.data(:,6)	= mean(tests.g6,2);
outs.e(:,6)		= std( tests.g6,0,2);
outs.data(:,7)	= mean(tests.g7,2);
outs.e(:,7)		= std( tests.g7,0,2);
outs.data(:,8)	= mean(tests.g8,2);
outs.e(:,8)		= std( tests.g8,0,2);



figure
hold on
%title([''])

spacing = length(outs.data)/20;
colors = brighten(jet(8),0.5); % jet() hsv() lines()

ph = [];
for i=1:8
	p = plot(	ep,outs.data(:,i), ...
					'LineWidth', 3, ...
					'Color',colors(i,:) );
	
	ph = [ph p];
	
	errorbar(1:spacing:length(ep), outs.data(1:spacing:end,i), outs.e(1:spacing:end,i), ...
				'x', ...
				'LineWidth', 2, ...
				'Color',colors(i,:) );
end

legend(ph,'0', '1', '2', '3', '4', '5', '6', '7', '8');
xlabel('Episode');
ylabel('Average error per frame');


save2pdf('./data.pdf')

