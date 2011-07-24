function xdot = noncontact_model( t, x , sys)

	g	= sys.parms.g;

	F = (-sys.K*x);
	
	xdot = sys.Ancon*x + sys.Bncon*[F; g];

end