%function [ ] = partA( )

% speeds between 2.5 and 9

% check eigenvalues (poles) over the range of velocites

poles = [];
flag = 0;
vs = [0 0];

for v = 2.5:0.001:9
	[A B C D] = createSysMats(v);
	poles = [poles; eig(A)'];
	
	p = eig(A);
	
	if flag==0
		if (p(1) < 0) && (p(2) < 0) && (p(3) < 0) && (p(4) < 0)
			vs(1) = v;
			flag = 1;
		end
	elseif flag == 1;
		if (p(1) >= 0) || (p(2) >= 0) || (p(3) >= 0) || (p(4) >= 0)
			vs(2) = v;
			flag = 2;
		end
	end
	
	
end
v = 2.5:0.001:9;

figure
title('System poles for v = [2.5, 9]');
hold on

plot([2.5 9], [0 0], 'k');
plot([vs(1) vs(1)], [-30 5], 'k');
plot([vs(2) vs(2)], [-30 5], 'k');

pr = real(poles);
plot(	v(1:200:end), pr(1:200:end,:) ,...
		'.',...
		'MarkerSize',10,...
		'LineWidth', 1);
	

text( vs(1)+(vs(2)-vs(1))/2,	-10,...
		'\leftarrow Stable \rightarrow',...
		'HorizontalAlignment','center',...
		'FontSize',8);
text( vs(1),	-10,...
		[num2str(vs(1)) ' \rightarrow'],...
		'HorizontalAlignment','right',...
		'FontSize',8);
text( vs(2),	-10,...
		['\leftarrow ' num2str(vs(2))],...
		'HorizontalAlignment','left',...
		'FontSize',8);
	
xlabel('Velocity (m/s)');
ylabel('Real part of pole');

xlim([2.5 9]);

save2pdf('./figures/partA.pdf')

%end

