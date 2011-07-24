function [ Acon Ancon Bcon Bncon C D ] = createABCD_force( sys )

	k = sys.parms.k;
	mm = sys.parms.mm;
	mB = sys.parms.mB;
	
	Acon = [	0,			1,			0,			0,	0;
				-k/mm,		0,			k/mm,		0,	0;
				0,			0,			0,			1,	0;
				k/mB,		0,			-k/mB,		0,	0;
				0,			k,			0,			-k,	0];

	Ancon = [	0,		1,		0,		0,	0;
				0,		0,		0,		0,	0;
				0,		0,		0,		1,	0;
				0,		0,		0,		0,	0;
				0,		0,		0,		0,	0];

	Bcon = [	0		0;
				1/mm	0;
				0		0;
				0		-1;
				0		0];

	Bncon = [	0		0;
				1/mm	0;
				0		0;
				0		-1;
				0		0];

	C = [1 0 0 0;...
		 0 0 1 0];

	D = 0;


end

