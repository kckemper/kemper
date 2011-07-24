display('starting!')
clear
close all
addpath ./functions;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Parameters:
sys.parms.x0		= [0 0 0 -20 0];

sys.parms.alim		= 1;
sys.parms.dlim		= 1;

sys.Flim			= 350;


sys.parms.mm		= 1;					% motor mass
sys.parms.mB		= 1;					% body mass

sys.parms.l0		= 1;
sys.parms.ls		= 0.5;

k	= 1000;
sys.parms.k			= k;
% sys.parms.k			= 100;					% spring constant

sys.parms.g			= 9.81;

sys.parms.t_stop	= 0.5;					% time where the load is stopped

t_end				= sys.parms.t_stop;				% time to stop graphing the equation
nSteps				= 1e6;

% sys.F				= 50;
sys.tF				= sys.parms.t_stop;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t_fix		= linspace(0,t_end,nSteps);



[sys.Acon sys.Ancon sys.Bcon sys.Bncon sys.C sys.D] = createABCD_force(sys);

%fg = sys.parms.g*sys.parms.mB;
fg = 0;

Q = eye(5);
R = eye(1)*1;

Q(1,1)=0;
Q(2,2)=0;
Q(3,3)=10000;
Q(4,4)=0;
Q(5,5)=10;

[K,P,e] = lqr(sys.Acon,sys.Bcon(:,1),Q,R);

sys.K = K;

% sys.Acon	= sys.Acon	-sys.Bcon*[K+fg; 0 0 0 0 0];
% sys.Ancon	= sys.Ancon	-sys.Bcon*[K+fg; 0 0 0 0 0];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


out_lin = catch_sim(sys,2);

sys_lin = sys;
sys_lin.x			= out_lin.x;
sys_lin.t			= out_lin.t;
sys_lin.evnt		= out_lin.evnt;
sys_lin.u			= -K*sys_lin.x';

sys_lin.u(sys_lin.u < -sys.Flim) = -sys.Flim;
sys_lin.u(sys_lin.u >  sys.Flim) = sys.Flim;


sys.parms.k	= k;
out_nlin = catch_sim(sys,3);

sys_nlin = sys;
sys_nlin.x			= out_nlin.x;
sys_nlin.t			= out_nlin.t;
sys_nlin.evnt		= out_nlin.evnt;
sys_nlin.u			= -K*sys_nlin.x';

sys_nlin.u(sys_nlin.u < -sys.Flim) = -sys.Flim;
sys_nlin.u(sys_nlin.u >  sys.Flim) = sys.Flim;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot

%plot(sys.t,sys.x), xlabel('Time (sec)'), ylabel('Displacement (m) and Velocity (m/s)')
% graphSys(sys_lin);


graphForce(sys_lin);
save2pdf('../images/force_LQR3.pdf');

graphPos(sys_lin);
save2pdf('../images/pos_LQR3.pdf');

% graphForceNonlin(sys_nlin);
% save2pdf('../images/force_LQR3_nonlin.pdf');
% 
% graphPos(sys_nlin);
% save2pdf('../images/pos_LQR3_nonlin.pdf');




figure('position',[600 600 500 300]);
title('Input Force');
hold on

plot(	[sys_lin.t(1) sys_lin.t(round(end/3))], [0 0],...
		'--k',...
		'MarkerSize',10,...
		'LineWidth', 2);

plot(	[sys_lin.t(1) sys_lin.t(round(end/3))], [sys.Flim sys.Flim],...
	'--r',...
	'MarkerSize',10,...
	'LineWidth', 2);

plot(	[sys_lin.t(1) sys_lin.t(round(end/3))], [-sys.Flim -sys.Flim],...
	'--r',...
	'MarkerSize',10,...
	'LineWidth', 2);

plot(	sys_lin.t(1:round(end/3)), sys_lin.u(1:round(end/3))',...
		'-',...
		'MarkerSize',10,...
		'LineWidth', 3);

xlabel('Time (s)');
ylabel('Force (N)');

save2pdf('../images/force_LQR3_nonlin_zoom.pdf');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Animate
sys_lin.xm			= sys_lin.x(:,1);
sys_lin.xL			= sys_lin.x(:,3);
animate(sys_lin,50,0.1);





