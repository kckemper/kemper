close all
clear all


r	= linspace(-1,1,1e3);


h1 = zeros(size(r));
h2 = -r.^2/4;


figure('position',[200 200 400 300]);

hold on

plot(	[0 0] , [h2(1) abs(h2(1))],...
		'-k',...
		'LineWidth', 1);
%
plot(	[r(1) r(end)] , [0 0],...
		'-k',...
		'LineWidth', 1);
%

% hd1 = area([r(1) r(end)], [0 0]);

% hd2 = area([r(1) r(end)], [abs(h2(1)) abs(h2(1))]);
% set(hd2,'FaceColor',[1 1 1])

% hd3 = area([r(1) r(end)], [h2(1) h2(1)]);
% set(hd3,'FaceColor',[0.75 0.75 0.75])
% 
% hd4 = area(r, h2);
% set(hd4,'FaceColor',[0.5 0.5 0.5])
% 
% set([hd1 hd4],'LineStyle','-','LineWidth',1)


		
p2 = plot(	r, h2,...
			'-',...
			'LineWidth', 2);
%

p1 = plot(	0, 0,...
			'.r',...
			'markersize',20,...
			'LineWidth', 3);
%

axis off


text(r(end),h2(end),	'$h=-\frac{r^{2}}{4}\rightarrow$',...
						    'HorizontalAlignment','right',...
							'fontsize',12,...
							'interpreter','latex')
%

text(r(end/2),abs(h2(1)/2),	'$1\ $',...
						    'HorizontalAlignment','right',...
							'fontsize',20,...
							'FontWeight','bold',...
							'interpreter','latex')
%

text(r(end/2),h2(1)/2,		'$2\ $',...
						    'HorizontalAlignment','right',...
							'fontsize',20,...
							'FontWeight','bold',...
							'interpreter','latex')
%


text(0,abs(h2(1)),	'$\ h$',...
						    'HorizontalAlignment','left',...
							'fontsize',14,...
							'interpreter','latex')
%						
text(r(end),0,	'$\ \ r$',...
						    'HorizontalAlignment','left',...
							'fontsize',14,...
							'interpreter','latex')
%

legend([p1 p2],'Transcritical','Saddle','location','northeast')

xlabel('r');
ylabel('x');

save2pdf('./images/prob4_3.pdf');