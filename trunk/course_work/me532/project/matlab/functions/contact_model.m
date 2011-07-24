function xdot = contact_model( t, x , sys)

	g	= sys.parms.g;

	F = (-sys.K*x);
	
	xdot = sys.Acon*x + sys.Bcon*[F; g];

end