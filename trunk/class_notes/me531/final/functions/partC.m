function [ ] = partC ( )

% Full state feedback regulator (u=r-kx, r=0) using a Bessel polynomial. Plot
% stear and lean angle time response and T.

v = 4;
Ts = 2;

[A B C D] = createSysMats(v);

% create list of pole locations using the 4th order Bessel polynomial.
poles = [-4.0156+5.0723j -4.0156-5.0723j -5.5281+1.6553j -5.5281-1.6553j]/Ts;

% Find the gain matrix, K that will generate these poles in closed-loop.
K = place(A,B,poles);

% Generate new A matrix for our closed-loop system.
Acl = A-B*K;


syscl =  ss(Acl,B,C,D);

% Simulate the response with inital conditions X0 = [ 0.05; 0; 0.1; 0];
X0 = [ 0.05; 0; 0.1; 0];

t = 0:.001:3;
r = zeros(length(t),2);

[Y,t,X] = lsim(syscl,r,t,X0);


U	= -K*X';

figure
title('State variables \phi and \delta');
hold on

plot([0 3], [0 0], 'k');

p = plot(	t, [X(:,1) X(:,3)],...
			'-',...
			'MarkerSize',10,...
			'LineWidth', 3);
	
xlabel('Time (s)');
ylabel('Angle (rad)');
legend(p,'\phi - lean','\delta - steering');

save2pdf('./figures/partC1.pdf');

figure
title('Input torques');
hold on

plot([0 3], [0 0], 'k');

p = plot(	t, U,...
		'-',...
		'MarkerSize',10,...
		'LineWidth', 3);
	
xlabel('Time (s)');
ylabel('Torque (N/m)');
legend(p,'T_\phi','T_\delta');

save2pdf('./figures/partC2.pdf');

end

