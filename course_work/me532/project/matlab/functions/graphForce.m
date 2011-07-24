function [] = graphForce( sys )
%GRAPHFORCE graphs the work done by the actuator and the input force
%	sys.x	: state vector
%	sys.t	: time

	xm	= sys.x(:,1);
	xB	= sys.x(:,3);

	t	= sys.t;
	
	k	= sys.parms.k;
	l0	= sys.parms.l0;
	ls	= sys.parms.ls;
	

	FB	= (k/ls^2)*(xm-xB);

	% mask off times where the actuator isn't in contact
	tz  = sys.t(FB<0);
	FBz = FB(FB<0).*0;
	FB(FB<0) = 0;

	
	figure('position',[600 600 500 300]);
	subplot(2,1,1)
%	prettyPlot(t,FB,'Force applied to the load','Time (sec)','Force (N)');

	hold on
	title('Force applied to the body')

	plot(	t,	FB, ...
			'LineWidth', 3);

	xlabel('Time (s)');
	ylabel('Force (N)');

	
	plot(	t(FB(2:end)==0), FB(FB(2:end)==0)',...
		'.r',...
		'MarkerSize',4,...
		'LineWidth', 3);

	subplot(2,1,2)
	title('Input Force');
	hold on

	plot(	[t(1) t(end)], [0 0],...
			'--k',...
			'MarkerSize',10,...
			'LineWidth', 2);
	
	plot(	t, sys.u',...
			'-',...
			'MarkerSize',10,...
			'LineWidth', 3);

	xlabel('Time (s)');
	ylabel('Force (N)');


end