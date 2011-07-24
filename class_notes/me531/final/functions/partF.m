function [ ] = partF( )

	% Design a full-order estimator using part C poles
	rss =[0.1; 0.2];
	v = 4;
	Ts = 2;

	[A B C D] = createSysMats(v);

	% create list of pole locations using the 4th order Bessel polynomial.
	poles = [-4.0156+5.0723j -4.0156-5.0723j -5.5281+1.6553j -5.5281-1.6553j]/Ts;


	% Place estimator poles 5-10 times faster than desired pole locations.
	Gtrans = place(A',C',[-10 -10 -15 -15]);
	G = Gtrans';

	K = place(A,B,poles);

	tmp = [A B; C D] \ [zeros(1,length(A)) rss']';
	xss = tmp(1:length(A(1,:)),:);
	uss = tmp(length(A(1,:))+1:end,:);
	% xss = Nx rss
	% uss = Nu rss
	Nx = xss/rss;
	Nu = uss/rss;

	Nbar = Nu + K*Nx;

	Aest = [A, -B*K; G*C, A-B*K-G*C];
	Best = [B*Nbar; B*Nbar];
	Cest = [C zeros(size(C)); zeros(size(C)) C];
	Dest = [D; D];

	sysclest = ss(Aest,Best,Cest,Dest);

	t = 0:0.001:3;
	r = [ones(length(t),1)*0.1 ones(length(t),1)*0.2];


	X0 = [ 0.05; 0; 0.1; 0];

	[Y,t,X] = lsim(sysclest,r,t,[X0; 0; 0; 0; 0]);


	figure
	title('State variables \phi and \delta');
	hold on

	colors = brighten(lines(4),0.5); % jet() hsv() lines()

	plot([0 3], [0.2 0.2], 'k');
	plot([0 3], [0.1 0.1], 'k');

	p1 = plot(	t, Y(:,1),...
				'-',...
				'Color',colors(1,:),...
				'LineWidth', 3);
	p2 = plot(	t, Y(:,2),...
				'-',...
				'Color',colors(2,:),...
				'LineWidth', 3);
			
	p3 = plot(	t, Y(:,3),...
				'--',...
				'Color',colors(3,:),...
				'LineWidth', 3);
	p4 = plot(	t, Y(:,4),...
				'--',...
				'Color',colors(4,:),...
				'LineWidth', 3);

			
	xlabel('Time (s)');
	ylabel('Angle (rad)');
	legend([p1 p3 p2 p4],'\phi','\phi - estimate','\delta','\delta - estimate','Location','SouthEast');

	save2pdf('./figures/partF1.pdf');

end

