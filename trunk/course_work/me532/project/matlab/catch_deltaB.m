display('starting!')
clear
close all
addpath ./functions;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Parameters:
sys.parms.x0		= [0 0 0 -16];

sys.parms.mL		= 2;					% load mass
sys.parms.ma		= 10;					% actuator mass

sys.parms.k			= 1000;					% spring constant
sys.parms.B			= 1;

sys.parms.t_stop	= 2;					% time where the load is stopped

t_end		= sys.parms.t_stop;				% time to stop graphing the equation
nSteps		= 1e5;							% number of time setps for evaluating the functions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t_fix		= linspace(0,t_end,nSteps);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sys.F		= 100;
sys.F_t	= sys.parms.t_stop;

data.Fpeak	= [];
data.v		= [];
v = 0;
for B = 0:10:100
	
	sys.parms.B = B;
	[sys.Acon sys.Ancon sys.Bcon sys.Bncon sys.C sys.D] = createABCD(sys);
	
	for v = 100:-1:0
		sys.parms.x0 = [0 0 0 -v];
		out = catch_sim(sys);
		
		if out.evnt.typ(end) ~= 2
			break;
		end
	end
	
	Fpeak = max(sys.parms.k.*(out.x(:,1)-out.x(:,3)) + sys.parms.B.*(out.x(:,2)-out.x(:,4)));
	data.Fpeak	= [data.Fpeak Fpeak];
	
	data.v		= [data.v v];
	display(v);
	
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot

% graphSys(sys);
% 
% graphForce(sys);
% graphWork(sys);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Animate
% animate(sys,50,0.05);



