function [ ] = partD( )

% Full state feedback regulator (u=Nr-kx, r=[0.1; 0.2]) using a Bessel polynomial. Plot
% stear and lean angle time response and T.

rss =[0.1; 0.2];
v	= 4;
Ts	= 2;

[A B C D] = createSysMats(v);

% create list of pole locations using the 4th order Bessel polynomial.
poles = [-4.0156+5.0723j -4.0156-5.0723j -5.5281+1.6553j -5.5281-1.6553j]/Ts;

% Find the gain matrix, K that will generate these poles in closed-loop.
K = place(A,B,poles);

tmp = [A B; C D] \ [zeros(1,length(A)) rss']';
xss = tmp(1:length(A(1,:)),:);
uss = tmp(length(A(1,:))+1:end,:);

% xss = Nx rss
% uss = Nu rss
Nx = xss/rss;
Nu = uss/rss;

Nbar = Nu + K*Nx;


% Generate new matrices for our closed-loop system.
Acl = A-B*K;
Bcl = B*Nbar;

syscl =  ss(Acl,Bcl,C,0);

% Simulate the response with inital conditions X0 = [ 0.05; 0; 0.1; 0];
X0 = [ 0.05; 0; 0.1; 0];

t = 0:.001:3;

r = [ones(length(t),1)*0.1 ones(length(t),1)*0.2];

[Y,t,X] = lsim(syscl,r,t,X0);


U	= Nbar*r'-K*X';

figure
title('State variables \phi and \delta');
hold on

plot([0 3], [0.2 0.2], 'k');
plot([0 3], [0.1 0.1], 'k');

p = plot(	t, [X(:,1) X(:,3)],...
			'-',...
			'MarkerSize',10,...
			'LineWidth', 3);
	
xlabel('Time (s)');
ylabel('Angle (rad)');
legend(p,'\phi','\delta','Location','SouthEast');

save2pdf('./figures/partD1.pdf');

figure
title('Input torques');
hold on

plot(	t, U,...
		'-',...
		'MarkerSize',10,...
		'LineWidth', 3);
	
xlabel('Time (s)');
ylabel('Torque (N/m)');
legend('T_\phi','T_\delta','Location','East');

save2pdf('./figures/partD2.pdf');


end

