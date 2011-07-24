close all
clear all



u = linspace(-1,3,1e3);

% Fixed points
ptx1 = 0;
ptu1 = 0;

ptx2 = 0;
ptu2 = 1;

ptx3 = 1/2;
ptu3 = -1/4;

ptx4 = 1;
ptu4 = 2;

ptx5 = -1;
ptu5 = 2;

%%%%%
x1 = zeros(size(u));
x2 = (1+sqrt(1+4*u))/2;
x3 = (1-sqrt(1+4*u))/2;
x4 = sqrt(-1+u);
x5 = -sqrt(-1+u);


% stable segments:
us1 = linspace(ptu3,3,1e3);
xs1 = (1+sqrt(1+4*us1))/2;

us2 = linspace(-1,ptu1,1e3);
xs2 = zeros(size(us1));

us3 = linspace(ptu1,ptu5,1e3);
xs3 = (1-sqrt(1+4*us3))/2;

us4 = linspace(ptu2,3,1e3);
xs4 = zeros(size(us4));

us5 = linspace(ptu5,3,1e3);
xs5 = -sqrt(-1+us5);

% unstable segments:
uu1 = linspace(ptu3,ptu1,1e3);
xu1 = (1-sqrt(1+4*uu1))/2;

uu2 = linspace(ptu1,ptu2,1e3);
xu2 = zeros(size(uu2));

uu3 = linspace(ptu2,ptu4,1e3);
xu3 = sqrt(-1+uu3);

uu4 = linspace(ptu2,ptu5,1e3);
xu4 = -sqrt(-1+uu4);

uu5 = linspace(ptu4,3,1e3);
xu5 = sqrt(-1+uu5);

uu6 = linspace(ptu5,3,1e3);
xu6 = (1-sqrt(1+4*uu6))/2;

%%%%%
dfdx1 = u - u.^2 + 2.*x1 - 2.*u.*x1 - 3.*x1.^2 + 6.*u.*x1.^2 + 4.*x1.^3 - 5.*x1.^4;
dfdx2 = u - u.^2 + 2.*x2 - 2.*u.*x2 - 3.*x2.^2 + 6.*u.*x2.^2 + 4.*x2.^3 - 5.*x2.^4;
dfdx3 = u - u.^2 + 2.*x3 - 2.*u.*x3 - 3.*x3.^2 + 6.*u.*x3.^2 + 4.*x3.^3 - 5.*x3.^4;
dfdx4 = u - u.^2 + 2.*x4 - 2.*u.*x4 - 3.*x4.^2 + 6.*u.*x4.^2 + 4.*x4.^3 - 5.*x4.^4;
dfdx5 = u - u.^2 + 2.*x5 - 2.*u.*x5 - 3.*x5.^2 + 6.*u.*x5.^2 + 4.*x5.^3 - 5.*x5.^4;


%%%%%
figure('position',[200 200 500 500]);

hold on

% plot axis:s
plot(	[0 0] , [x3(end) x2(end)],...
		'-k',...
		'LineWidth', 1);
%

% h1 = plot(	u, [x1; x2; x3; x4; x5],...
% 			'-b',...
% 			'LineWidth', 2);
% %



% plot stable segments:
hs1 = plot(	us1, xs1,...
			'-',...
			'LineWidth', 2);
%
hs2 = plot(	us2, xs2,...
			'-',...
			'LineWidth', 2);
%
hs3 = plot(	us3, xs3,...
			'-',...
			'LineWidth', 2);
%
hs4 = plot(	us4, xs4,...
			'-',...
			'LineWidth', 2);
%
hs5 = plot(	us5, xs5,...
			'-',...
			'LineWidth', 2);
%


%plot unstable segments:
hu1 = plot(	uu1, xu1,...
			'--',...
			'LineWidth', 2);
%
hu2 = plot(	uu2, xu2,...
			'--',...
			'LineWidth', 2);
%
hu3 = plot(	uu3, xu3,...
			'--',...
			'LineWidth', 2);
%
hu4 = plot(	uu4, xu4,...
			'--',...
			'LineWidth', 2);
%
hu5 = plot(	uu5, xu5,...
			'--',...
			'LineWidth', 2);
%
hu6 = plot(	uu6, xu6,...
			'--',...
			'LineWidth', 2);
%

% plot bifurcation points:
pt1 = plot( ptu1, ptx1, '.g', 'markersize',20); % transcritical
pt2 = plot( ptu2, ptx2, '.c', 'markersize',20); % pitchfork
pt3 = plot( ptu3, ptx3, '.r', 'markersize',20); % saddle
%pt4 = plot( ptu4, ptx4, '.r', 'markersize',20); % saddle
pt5 = plot( ptu5, ptx5, '.g', 'markersize',20); % transcritical

axis off

text(u(end/2),x2(end/2),	'$x=\frac{1+\sqrt{1+4\mu}}{2} \rightarrow\,$',...
						    'HorizontalAlignment','right',...
							'fontsize',10,...
							'interpreter','latex')
%

text(u(round(2*end/3)),x3(round(2*end/3)),	'$x=\frac{1-\ \sqrt{1+4\mu}}{2} \rightarrow\,$',...
						    'HorizontalAlignment','right',...
							'fontsize',10,...
							'interpreter','latex')
%

text(u(round(2*end/3)),x4(round(2*end/3)),	'$x=\sqrt{-1+\mu} \rightarrow\,$',...
						    'HorizontalAlignment','right',...
							'fontsize',10,...
							'interpreter','latex')
%

text(u(round(2*end/3)),x5(round(2*end/3)),	'$\ \leftarrow \, x=-\sqrt{-1+\mu}$',...
						    'HorizontalAlignment','left',...
							'fontsize',10,...
							'interpreter','latex')
%
text(0,x2(end),	'$\ x$',...
						    'HorizontalAlignment','left',...
							'fontsize',14,...
							'interpreter','latex')
%
text(u(end),0,	'$\ \ \mu$',...
						    'HorizontalAlignment','left',...
							'fontsize',14,...
							'interpreter','latex')
%

legend([hs1 hu1,pt1,pt2,pt3],'stable','unstable','transcritical','pitchfork','saddle','location','southwest')
		
save2pdf('./images/prob3_1.pdf');