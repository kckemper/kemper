function plotResults( results )

	clip = 100;

	h = figure('Name',['Velocity']);
	set(h,'position',[ 100 100 500 350])

	%subplot(3,1,1:2)
	hold on

	nB = length(results.B);
%	nB = 5;
	
	for idx = 1:1:nB
		hd = area(results.k(1:clip),results.v(1:clip,nB+1-idx));
		set(hd,'FaceColor',[(nB-idx+1)/(nB+0.1) (nB-idx+1)/(nB+0.1) (nB-idx+1)/(nB+0.1) ])
	end
	
%	plot([Bs(1) Bs(nB_steps)],[ sqrt(parms.tau_limit/(parms.A*parms.Im ))/(2*pi) sqrt(parms.tau_limit/(parms.A*parms.Im ))/(2*pi) ],'w--','LineWidth',2 )

% 	h = legend(	['B=' num2str(results.B(5))],...
% 				['B=' num2str(results.B(4))],...
% 				['B=' num2str(results.B(3))],...
% 				['B=' num2str(results.B(2))],...
% 				['B=' num2str(results.B(1))]);
% 	set(h,'Location','NorthEast','fontsize',14);

	% for i = nk_steps-1:-1:2
	%  	plot(2*sqrt(ks(i)*parms.Im), fs(i ,find(Bs <= 2*sqrt(ks(i)*parms.Im),1,'last') ),'r.','MarkerSize',20)
	% end

% 	for idx = 1:1:nB
% 		tmp = find(results.evnt(:,idx) == 2,idx);
% 		plot(results.k(1:tmp-1),results.v(1:tmp-1,idx),'r.');
% 		plot(results.k(tmp:end),results.v(tmp:end,idx),'b.');
% 	end
% 	
	xlabel(	'\textbf{k} $\left(\frac{N}{m} \right)$',...
			'interpreter','latex','fontsize',16);

	ylabel(	'\textbf{Velocity} $\left( \frac{m}{s} \right)$',...
			'interpreter','latex','fontsize',16);


	set(gca,'FontSize',14)

	axis tight

%	save2pdf('./figures/results.pdf');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	h = figure('Name',['Peak force']);
	set(h,'position',[ 650 100 500 350])

	%subplot(3,1,1:2)
	hold on

	nB = length(results.B);
%	nB = 5;
	
	for idx = 1:1:nB
		hd = area(results.k(1:clip),results.Fpeak(1:clip,nB+1-idx));
		set(hd,'FaceColor',[(nB-idx+1)/(nB+0.1) (nB-idx+1)/(nB+0.1) (nB-idx+1)/(nB+0.1) ])
	end
	
%	plot([Bs(1) Bs(nB_steps)],[ sqrt(parms.tau_limit/(parms.A*parms.Im ))/(2*pi) sqrt(parms.tau_limit/(parms.A*parms.Im ))/(2*pi) ],'w--','LineWidth',2 )

% 	h = legend(	['B=' num2str(results.B(5))],...
% 				['B=' num2str(results.B(4))],...
% 				['B=' num2str(results.B(3))],...
% 				['B=' num2str(results.B(2))],...
% 				['B=' num2str(results.B(1))]);
% 	set(h,'Location','NorthEast','fontsize',14);

	% for i = nk_steps-1:-1:2
	%  	plot(2*sqrt(ks(i)*parms.Im), fs(i ,find(Bs <= 2*sqrt(ks(i)*parms.Im),1,'last') ),'r.','MarkerSize',20)
	% end

	xlabel(	'\textbf{k} $\left(\frac{N}{m} \right)$',...
			'interpreter','latex','fontsize',16);

	ylabel(	'\textbf{F_peak} $\left( N \right)$',...
			'interpreter','latex','fontsize',16);


	set(gca,'FontSize',14)

	axis tight

%	save2pdf('./figures/results.pdf');


end

