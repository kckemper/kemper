function [ ] = partH( )



	% output tracking
	v = 4;
	Ts = 2;

	[A B C D] = createSysMats(v);


	% create list of pole locations using the 4th order Bessel polynomial.
	poles = [-4.0156+5.0723j -4.0156-5.0723j -5.5281+1.6553j -5.5281-1.6553j]/Ts;


	% Place estimator poles 5-10 times faster than desired pole locations.
	Gtrans = place(A',C',[-10 -10 -15 -15]);
	G = Gtrans';

	K = place(A,B,poles);


	% Compute degree:
	gamma = [];
	for i = 1:length(C(:,1))

		tmp = -1;
		j = 1;
		while (tmp ~= 0)
			tmp = C(i,:)*A^(j-1)*B;
			j=j+1;
		end
		gamma = [gamma j];
	end

	Z = [];
	coeffs = [];
	for i = 1:length(gamma)
		Z = [Z; C(i,:)*A^(gamma(i)-1)*B];
		coeffs = [coeffs; C(i,:)*A^gamma(i)];
	end

	Zinv = inv(Z);


	
	errorcharacteristic = conv([1 2],[1 5]);
	
	alpha11 = errorcharacteristic(2);
	alpha12 = errorcharacteristic(3);
	alpha21 = errorcharacteristic(2);
	alpha22 = errorcharacteristic(3);


	alpha	= [0 1 0 0; alpha12 alpha11 0 0; 0 0 0 1; 0 0 alpha22 alpha21];
	alpham	= [0 1 0 0; -alpha12 -alpha11 0 0; 0 0 0 1; 0 0 -alpha22 -alpha21];
	beta	= [0 1 0 0; 0 0 0 1];



	A11		= A - B*Zinv*C*A^2;
	A12		= zeros(4);
	A13		= B*Zinv*beta*alpha;

	A21		= G*C - B*Zinv*C*A^2;
	A22		= A-G*C;
	A23		= B*Zinv*beta*alpha;

	A31		= zeros(4);
	A32		= zeros(4);
	A33		= alpham;

	Anew = [A11 A12 A13; A21 A22 A23; A31 A32 A33];
	Bnew = [B; B; zeros(size(B))];
	Cnew = [C zeros(size(C)) zeros(size(C)); zeros(size(C)) C zeros(size(C)); zeros(size(C)) zeros(size(C)) zeros(size(C))];
	Dnew = zeros(6,2);
	% Form the closed loop system with tracking control
	syscl = ss(Anew,Bnew,Cnew,Dnew);



	t = 0:0.001:1*pi;
	
	% generate inputs
	u = Zinv*[-0.15*sin(t); -0.6*sin(2*t)];


	% Initial conditions for states
	X0 = [ 0.05; 0; 0.1; 0];
	Y0 = [ 0.05; 0; 0.1; 0];
	% Initial conditions for error dynamics and state estimates
	ic  = [0; 0; 0; 0];
	
	% e = yd - y
	ice = [0.15*sin(0); 0.15*cos(0); 0.15*sin(0); 0.30*cos(0)] - Y0;
	
	% Simulate system dynamics and error dynamics from initial conditions
	[Y,t,X] = lsim(syscl,u,t,[X0; ic; ice]);

	figure
	hold on
	title('State variables \phi and \delta');
	
	colors = brighten(lines(6),0.5); % jet() hsv() lines()

	% yd
	p1 = plot(	t,0.15*sin(t),...
				'-',...
				'Color',colors(1,:),...
				'LineWidth', 3);
	p2 = plot(	t, 0.15*sin(2*t),...
				'-',...
				'Color',colors(2,:),...
				'LineWidth', 3);
	
	% y
	p3 = plot(	t,Y(:,1),...
				'--',...
				'Color',colors(3,:),...
				'LineWidth', 3);
	p4 = plot(	t, Y(:,2),...
				'--',...
				'Color',colors(4,:),...
				'LineWidth', 3);
	% y^
	p5 = plot(	t,Y(:,3),...
				'-.',...
				'Color',colors(5,:),...
				'LineWidth', 3);
	p6 = plot(	t, Y(:,4),...
				'-.',...
				'Color',colors(6,:),...
				'LineWidth', 3);
			
	xlabel('Time (s)');
	ylabel('Angle (rad)');
	legend([p1 p2 p3 p4 p5 p6],'\phi - desired','\delta - desired','\phi','\delta','\phi - estimate','\delta - estimate','Location','NorthEast');

	save2pdf('./figures/partH.pdf');

end

