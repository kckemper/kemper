function [ ] = graphSys( sys )

	figure('position',[10 600 500 300]);
	
	str = sprintf('State variables:\n $k=%d$, $m_m=%d$, $m_B=%d$, $\\dot{x}_B=%d$',sys.parms.k,sys.parms.mm,sys.parms.mB,sys.parms.x0(4));
	title(str,'interpreter','latex');
	
	
	hold on
	plot([0 sys.t(end)], [0 0], 'k');
	p = plot(	sys.t, sys.x,...
				'-',...
				'MarkerSize',10,...
				'LineWidth', 3);

	xlabel('Time (s)');
	ylabel('');
	legend(p,'x_1','x_2','x_3','x_4','Location','SouthEast');

	set(gca,'OuterPosition',[0 0 1 0.9]);
	
%	save2pdf('../images/sys.pdf');
	
end