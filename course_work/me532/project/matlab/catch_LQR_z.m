display('starting!')
clear
close all
addpath ./functions;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Parameters:
sys.parms.x0		= [0 0 0 -5];

sys.parms.alim		= 1;
sys.parms.dlim		= 1;

sys.parms.mm		= 1;					% motor mass
sys.parms.mB		= 1;					% body mass

sys.parms.l0		= 1;
sys.parms.ls		= 0.5;

k	= 1000;
sys.parms.k			= k/(sys.parms.ls^2);
% sys.parms.k		= 100;					% spring constant

sys.parms.g			= 9.81;

sys.parms.t_stop	= 1;					% time where the load is stopped

t_end				= sys.parms.t_stop;				% time to stop graphing the equation
nSteps				= 1e6;

% sys.F				= 50;
sys.tF				= sys.parms.t_stop;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t_fix		= linspace(0,t_end,nSteps);



[sys.Acon sys.Ancon sys.Bcon sys.Bncon sys.C sys.D] = createABCD(sys);

%fg = sys.parms.g*sys.parms.mB;
fg = 0;

R = eye(1);

c1 = sys.parms.k*10;
c3 = sys.parms.k*100;

Q = [	c1^2	0	-c1*c3		0;
		0		0		0		0;
		-c1*c3	0		c3^2	0;
		0		0		0		0];


[K,P,e] = lqr(sys.Acon,sys.Bcon(:,1),Q,R);

sys.K = K;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


out = catch_sim(sys,0);

sys.x			= out.x;
sys.t			= out.t;
sys.evnt		= out.evnt;
sys.u			= -K*sys.x';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot

graphForce(sys);
% save2pdf('../images/force_LQR_z2.pdf');

graphPos(sys);
% save2pdf('../images/pos_LQR_z2.pdf');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Animate
sys.xm			= sys.x(:,1);
sys.xL			= sys.x(:,3);
animate(sys,50,0.1);








