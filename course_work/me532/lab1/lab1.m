clear
close all
fprintf('\n\n\nstarting!\n')

sys.k = 40;
sys.c = 0.1;
sys.m = 1;

sys.A = [	0,		1;
			-sys.k/sys.m,	-sys.c/sys.m];
		
sys.B = [	0;
			1/sys.m];
		
sys.D = sys.B;

sys.u = 0;
sys.f = [];


alpha	= 1;
beta	= 1;

sys.Q	= [	alpha*(1/2)*sys.k,	0;
			0					beta*(1/2)*sys.m];

sys.R	= 1;

M	= zeros(size(sys.A));

options = odeset('RelTol',1e-3,'MaxStep',1e-3);

t0		= 0;
tend	= 10;

x0 = [1 0];



sys.PI_soln = ode45(@PI_de, [tend, t0], M, options, sys);


[t x] = ode45(@mass_spring_ode, [t0, tend], x0, options, sys);



figure
plot(t,x,'LineWidth',2);
legend('x_1','x_2');

figure
plot(x(:,1),x(:,2));
xlabel('position');
ylabel('velocity');






