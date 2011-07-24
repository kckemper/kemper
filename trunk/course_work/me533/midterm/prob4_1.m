close all
clear all


rn	= linspace(-1,0,1e1);
%rn	= rn(1:end-1);
rp	= linspace(0,1,1e1);

%r	= [rn rp];

p1 = rn/2;
p2 = zeros(size(rn));
p3 = rp/2;
p4 = zeros(size(rp));

figure('position',[200 200 400 300]);

hold on

plot(	[0 0] , [p1(1) p3(end)],...
		'-k',...
		'LineWidth', 1);
	
h1 = plot(	rn, p1,...
			'--',...
			'LineWidth', 2);
		
h2 = plot(	rn, p2,...
			'-',...
			'LineWidth', 2);

h3 = plot(	rp, p3,...
			'-',...
			'LineWidth', 2);

h4 = plot(	rp, p4,...
			'--',...
			'LineWidth', 2);
		
plot( 0, 0, '.r', 'markersize',20)
		
axis off

text(rp(end/2),p3(end/2),	'$\,\leftarrow\ \ x=\frac{r}{2}$',...
						    'HorizontalAlignment','left',...
							'fontsize',14,...
							'interpreter','latex')

text(0,p3(end),	'$\ x$',...
						    'HorizontalAlignment','left',...
							'fontsize',14,...
							'interpreter','latex')
						
text(rp(end),0,	'$\ \ r$',...
						    'HorizontalAlignment','left',...
							'fontsize',14,...
							'interpreter','latex')

legend([h1 h2],'unstable','stable','location','southeast')

xlabel('r');
ylabel('x');

save2pdf('./images/prob4_1.pdf');