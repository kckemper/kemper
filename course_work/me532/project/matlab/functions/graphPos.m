function [ ] = graphPos( sys )

	figure('position',[10 600 500 300]);
	
	str = sprintf('State variables:\n $k=%d$, $m_m=%d$, $m_B=%d$, $\\dot{x}_B=%d$',sys.parms.k,sys.parms.mm,sys.parms.mB,sys.parms.x0(4));
	title(str,'interpreter','latex');
	
	hold on
	plot([sys.t(1) sys.t(end)], [0 0], 'k');
	p = plot(	sys.t, sys.x(:,3),...
				'-',...
				'MarkerSize',10,...
				'LineWidth', 3);

	xlabel('Time (s)');
	ylabel('');
	legend(p,'Body position','Location','NorthEast');

	set(gca,'OuterPosition',[0 0 1 0.9]);
	
%	save2pdf('../images/sys.pdf');
	
end