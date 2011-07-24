function xdot = lin_contact_model( t, x , sys)
	
	mm	= sys.parms.mm;
	mB	= sys.parms.mB;
	k	= sys.parms.k;
	g	= sys.parms.g;
	l0	= sys.parms.l0;
	ls	= sys.parms.ls;
	
	F	= sys.F;

% 	xdot	= [	x(2);
% 				(1/mm)*F - (1/mm)*k;
% 				x(4);
% 				(1/mB)*k-g];

	xdot = sys.Acon*x + sys.Bcon*[sys.F; 9.81];

			
end
