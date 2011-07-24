function xdot = prob3_model( t, x, sys )
%MASS_SPRING_ODE Summary of this function goes here
%   Detailed explanation goes here


	% ydd = - y - e(-yd + 1/3 yd^3)

	% x1 = y
	% x2 = y'
	
	% x1' = x2
	% x2' = -x1 -e(-x2 +1/3 x2^3)
	
	xdot = [x(2); (-x(1) - sys.eps*(-x(2) + (1/3)*x(2)^3)) ];	

end