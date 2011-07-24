function xdot = nonlin_lim_contact_model( t, x , sys)

	mm	= sys.parms.mm;
	mB	= sys.parms.mB;
	k	= sys.parms.k;
	g	= sys.parms.g;
	l0	= sys.parms.l0;
	ls	= sys.parms.ls;

	F = (-sys.K*x);
	
	if F > sys.Flim
		F = sys.Flim;
	elseif F < -sys.Flim
		F = -sys.Flim;
	end
	
	l = l0 - x(1) + x(3);
	Fk = ( 2*k*sqrt(1-(l^2)/(4*ls^2))*(acos(l/(2*ls))-acos(l0/(2*ls))) ) / (ls);

	xdot	= [	x(2);
				(1/mm)*F - (1/mm)*Fk;
				x(4);
				(1/mB)*Fk-g;
				(k/ls^2)*(x(2)-x(4))];
end