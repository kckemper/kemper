display('starting!')
clear
close all
addpath ./functions;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Parameters:
sys.parms.x0		= [0 0 0 -5];

sys.parms.alim		= 1;
sys.parms.dlim		= 1;

sys.parms.mL		= 1;					% load mass
sys.parms.ma		= 10;					% actuator mass


sys.parms.k			= 1000;				% spring constant
sys.parms.B			= 1;

sys.parms.t_stop	= 2;					% sim time

t_end		= sys.parms.t_stop;				% time to stop graphing the equation
nSteps		= 1e5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t_fix		= linspace(0,t_end,nSteps);


[sys.Acon sys.Ancon sys.Bcon sys.Bncon sys.C sys.D] = createABCD(sys);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sys.tF		= t_fix;
sys.F		= 30*sin(t_fix*2*pi)+9.81;


out = catch_sim(sys);

sys.x			= out.x;
sys.t			= out.t;
sys.evnt		= out.evnt;



% Recreate the input to the system using sys.t
sys.u = interp1(sys.tF,sys.F,sys.t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot


graphForce(sys);

graphSys(sys);
%graphWork(sys);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Animate
animate(sys,50,0.1);







