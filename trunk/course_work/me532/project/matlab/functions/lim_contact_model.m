function xdot = lim_contact_model( t, x , sys)

	g	= sys.parms.g;

	F = (-sys.K*x);
	
	if F > sys.Flim
		F = sys.Flim;
	elseif F < -sys.Flim
		F = -sys.Flim;
	end
	
	xdot = sys.Acon*x + sys.Bcon*[F; g];

end