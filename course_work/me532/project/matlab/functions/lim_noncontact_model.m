function xdot = lim_noncontact_model( t, x , sys)

	g	= sys.parms.g;

	F = (-sys.K*x);
	
	if F > sys.Flim
		F = sys.Flim;
	elseif F < -sys.Flim
		F = -sys.Flim;
	end
	
	xdot = sys.Ancon*x + sys.Bncon*[F; g];

end