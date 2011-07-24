close all
clear all

h = -1;

pt1r = -2*sqrt(-h);
pt1x = -sqrt(-h);

pt2r = 2*sqrt(-h);
pt2x = sqrt(-h);

rn	= linspace(-10,pt1r,1e3);
rp	= linspace(pt2r,10,1e3);

p1 = (rn./2) + sqrt(4*h+rn.^2)/2;
p2 = (rn./2) - sqrt(4*h+rn.^2)/2;

p3 = (rp./2) + sqrt(4*h+rp.^2)/2;
p4 = (rp./2) - sqrt(4*h+rp.^2)/2;

figure('position',[200 200 400 300]);

hold on

plot(	[0 0] , [p2(1) p3(end)],...
		'-k',...
		'LineWidth', 1);

plot(	[rn(1) rp(end)] , [0 0],...
		'-k',...
		'LineWidth', 1);
	
h1 = plot(	rn, p1,...
			'--',...
			'LineWidth', 2);
		
h2 = plot(	rn, p2,...
			'-',...
			'LineWidth', 2);

h3 = plot(	rp, p3,...
			'--',...
			'LineWidth', 2);

h4 = plot(	rp, p4,...
			'-',...
			'LineWidth', 2);

		
plot( pt1r, pt1x, '.r', 'markersize',20);
plot( pt2r, pt2x, '.r', 'markersize',20);

axis off

text(pt1r,pt1x,	'$\ \left(-2\sqrt{-h},-\sqrt{-h}\right)\rightarrow\ $',...
						    'HorizontalAlignment','right',...
							'fontsize',10,...
							'interpreter','latex')

text(pt2r,pt2x,	'$\ \leftarrow\,\left(2\sqrt{-h},\sqrt{-h}\right)\ \ $',...
						    'HorizontalAlignment','left',...
							'fontsize',10,...
							'interpreter','latex')

						
text(rp(end/2),p3(end/2),	'$\,\leftarrow\ x=\frac{r+\sqrt{4h+r^{2}}}{2}$',...
						    'HorizontalAlignment','left',...
							'fontsize',12,...
							'interpreter','latex')

text(rn(end/2),p2(end/2),	'$x=\frac{r-\ \sqrt{4h+r^{2}}}{2}\rightarrow$',...
						    'HorizontalAlignment','right',...
							'fontsize',12,...
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

save2pdf('./images/prob4_2.pdf');