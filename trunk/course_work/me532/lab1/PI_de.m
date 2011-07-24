function dPIdt = PI_de(t, PI, sys)
	PI		= reshape(PI, size(sys.A));
	dPIdt	= -sys.A'*PI - PI*sys.A + PI*sys.B*inv(sys.R)*sys.B'*PI - sys.Q;
	dPIdt	= dPIdt(:);
end
