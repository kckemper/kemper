clear
close all
addpath ./functions;

l0	= 1;
ls	= 0.5;
k	= 1000;


x1	= 0;
x3	= linspace(0,-l0,1e6);

l	= l0 - x1 + x3;


Fk		= ( 2*k*sqrt(1-(l.^2)/(4*(ls)^2)).*(acos(l./(2*ls))-acos(l0/(2*ls))) ) / (ls);

Fk_lin	= -(k/(ls^2))*(x3);
% Fk_lin	= -(Fk(end))*(x3);

figure('position',[10 600 500 200]);
title('Spring Force: $k=1000$, $l_0=1$, $l_s=0.5$','interpreter','latex');

hold on

p = plot(	l, [Fk; Fk_lin],...
			'-',...
			'MarkerSize',10,...
			'LineWidth', 3);

xlabel('Length (m)');
ylabel('Force (N)');

legend('Nonlinear','linear');

set(gca,'OuterPosition',[0 0 1 0.9]);

save2pdf('../images/SpringFunctionApprox1.pdf');