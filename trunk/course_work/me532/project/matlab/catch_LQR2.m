display('starting!')
clear
close all
addpath ./functions;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Parameters:
sys.parms.x0		= [0 0 0 -20 0];

sys.parms.alim		= 1;
sys.parms.dlim		= 1;

sys.parms.mm		= 1;					% motor mass
sys.parms.mB		= 1;					% body mass

sys.parms.l0		= 1;
sys.parms.ls		= 0.5;

k	= 1000;
sys.parms.k			= k/(sys.parms.ls^2);
% sys.parms.k			= 100;					% spring constant

sys.parms.g			= 9.81;

sys.parms.t_stop	= 0.5;					% time where the load is stopped

t_end		= sys.parms.t_stop;				% time to stop graphing the equation
nSteps		= 1e6;

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
Q(3,3)=1000000;
Q(4,4)=0;
Q(5,5)=1000;

[K,P,e] = lqr(sys.Acon,sys.Bcon(:,1),Q,R);

sys.K = K;

% sys.Acon	= sys.Acon	-sys.Bcon*[K+fg; 0 0 0 0 0];
% sys.Ancon	= sys.Ancon	-sys.Bcon*[K+fg; 0 0 0 0 0];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


out_lin = catch_sim(sys,0);

sys_lin = sys;
sys_lin.x			= out_lin.x;
sys_lin.t			= out_lin.t;
sys_lin.evnt		= out_lin.evnt;
sys_lin.u			= -K*sys_lin.x';

sys.parms.k	= k;
out_nlin = catch_sim(sys,1);

sys_nlin = sys;
sys_nlin.x			= out_nlin.x;
sys_nlin.t			= out_nlin.t;
sys_nlin.evnt		= out_nlin.evnt;
sys_nlin.u			= -K*sys_nlin.x';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot

%plot(sys.t,sys.x), xlabel('Time (sec)'), ylabel('Displacement (m) and Velocity (m/s)')
% graphSys(sys_lin);


graphForce(sys_lin);
save2pdf('../images/force_LQR2.pdf');

graphPos(sys_lin);
save2pdf('../images/pos_LQR2.pdf');

% graphForceNonlin(sys_nlin);
% save2pdf('../images/force_LQR2_nonlin.pdf');
% 
% graphPos(sys_nlin);
% save2pdf('../images/pos_LQR2_nonlin.pdf');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Animate
sys_lin.xm			= sys_lin.x(:,1);
sys_lin.xL			= sys_lin.x(:,3);
animate(sys_lin,50,0.1);








