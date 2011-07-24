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

sys.parms.t_stop	= 0.5;					% time where the load is stopped

t_end				= sys.parms.t_stop;				% time to stop graphing the equation
nSteps				= 1e6;

% sys.F				= 50;
sys.tF				= sys.parms.t_stop;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t_fix		= linspace(0,t_end,nSteps);



[sys.Acon sys.Ancon sys.Bcon sys.Bncon sys.C sys.D] = createABCD(sys);

%fg = sys.parms.g*sys.parms.mB;
fg = 0;

Q = eye(4);
R = eye(1)*1;

Q(1,1)=0;
Q(2,2)=0;
Q(3,3)=100000;
Q(4,4)=1000;


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

%plot(sys.t,sys.x), xlabel('Time (sec)'), ylabel('Displacement (m) and Velocity (m/s)')
graphSys(sys);

graphForce(sys);
save2pdf('../images/force_LQR1.pdf');

graphPos(sys);
save2pdf('../images/pos_LQR1.pdf');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Animate
sys.xm			= sys.x(:,1);
sys.xL			= sys.x(:,3);
animate(sys,50,0.1);








