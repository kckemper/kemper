function xdot = smd_model( t, x, sys )
%MASS_SPRING_ODE Summary of this function goes here
%   Detailed explanation goes here

	f		= 10*sin(30*pi*t);
	
	xd		= [	sys.s + sys.a*cos(2*pi*sys.freq*t);
				-2*sys.a*sys.freq*pi*sin(2*sys.freq*pi*t)];
	
	xdd		= [	-2*sys.a*sys.freq*pi*sin(2*sys.freq*pi*t);
				-4*sys.a*sys.freq^2*pi^2*cos(2*sys.freq*pi*t)];
	
	%TODO: stack b_dot into the solver to actually find b
%	b		= ( sys.PI*(sys.A*xd - xdd) ) / ( -sys.A'-sys.PI*sys.B*sys.R^-1*sys.B' );

	u		= -inv(sys.R)*sys.B'*sys.PI*(x(1:2)-xd) - inv(sys.R)*sys.B'*x(3:end);
	
	xdot	= [sys.A*x(1:2) + sys.B*u + sys.F*f; -(sys.A'-sys.PI*sys.B*inv(sys.R)*sys.B')*x(3:end)-sys.PI*(sys.A*xd-xdd)];
	

end