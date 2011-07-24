function xdot = mass_spring_ode( t, x, sys )
%MASS_SPRING_ODE Summary of this function goes here
%   Detailed explanation goes here

%	sys.f = [sys.f sin(t*sqrt(sys.k/sys.m))];

%    xdot = sys.A*x + sys.B*sys.u + sys.D*sin(t*sqrt(sys.k/sys.m));
%    xdot = sys.A*x;

	P = eval_PI(t,sys.PI_soln,sys.A);
	K = sys.R\sys.B'*P;
	u = -K*x;
	xdot = sys.A*x + sys.B*u;

end

