display('starting!')
clear
close all
addpath ./functions;


% 340	360
% -19.1	-19.3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Parameters:
sys.parms.x0		= [0 0 0 -5];

sys.parms.mm		= 10;					% motor mass
sys.parms.mB		= 1;					% body mass

sys.parms.l0		= 1;
sys.parms.ls		= 0.5;

k	= 100;
% sys.parms.k			= 100;					% spring constant

sys.parms.g			= 9.81;

sys.parms.t_stop	= 2;					% time where the load is stopped

t_end		= sys.parms.t_stop;				% time to stop graphing the equation
nSteps		= 1e6;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t_fix		= linspace(0,t_end,nSteps);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sys.F		= 0;
sys.F_t		= sys.parms.t_stop;

sys.parms.k = k;
[sys.Acon sys.Ancon sys.Bcon sys.Bncon sys.C sys.D] = createABCD(sys);
out0 = catch_sim(sys,0);

sys.parms.k = k/(sys.parms.ls^2);
[sys.Acon sys.Ancon sys.Bcon sys.Bncon sys.C sys.D] = createABCD(sys);
out1 = catch_sim(sys,1);


l	= 0;
Fk		= ( 2*k*sqrt(1-(l.^2)/(4*(sys.parms.ls)^2)).*(acos(l./(2*sys.parms.ls))-acos(sys.parms.l0/(2*sys.parms.ls))) ) / (sys.parms.ls);

sys.parms.k = Fk(end);
[sys.Acon sys.Ancon sys.Bcon sys.Bncon sys.C sys.D] = createABCD(sys);
out2 = catch_sim(sys,1);

sys.parms.k = k;
out = out0;
sys.x			= out.x;
sys.t			= out.t;
sys.eventMask	= out.evnt;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot


%graphForce(sys);

graphSys(sys);


figure('position',[10 600 500 300]);

str = sprintf('State variables:\n $k=%d$, $m_m=%d$, $m_B=%d$, $\\dot{x}_B=%d$',k,sys.parms.mm,sys.parms.mB,sys.parms.x0(4));
title(str,'interpreter','latex');


hold on
plot([0 out0.t(end)], [0 0], 'k');
p0 = plot(	out0.t, [out0.x(:,1) out0.x(:,3)],...
			'-',...
			'MarkerSize',10,...
			'LineWidth', 2);
%
p1 = plot(	out1.t, [out1.x(:,1) out1.x(:,3)],...
			'--',...
			'MarkerSize',10,...
			'LineWidth', 2);
%
% p2 = plot(	out2.t, [out2.x(:,1) out2.x(:,3)],...
% 			'-.',...
% 			'MarkerSize',10,...
% 			'LineWidth', 2);
% %

xlabel('Time (s)');
ylabel('');
legend([p0(1) p1(1)],'nonlinear','k/ls^2','Location','SouthEast','interpreter','latex');

set(gca,'OuterPosition',[0 0 1 0.9]);

%save2pdf('../images/outs_100.pdf');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Animate
%animate(sys,100,0.1);







