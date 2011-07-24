clear
close all

fprintf('\n\n\nSTARTING!!\n');

sys.s		= 1;
sys.a		= 1;
sys.freq	= 10;


sys.k = 40;
sys.c = 0.1;
sys.m = 1;

sys.A = [	0,		1;
			-sys.k/sys.m,	-sys.c/sys.m];
		
sys.B = [	0;
			1/sys.m];
		
sys.F = sys.B;

sys.u = 0;
sys.f = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha	= 10;
beta	= 1;

sys.Q	= [	alpha*(1/2)*sys.k,	0;
			0					beta*(1/2)*sys.m];

sys.R	= 0.000001;


[sys.K,sys.PI,E] = lqr(sys.A,sys.B,sys.Q,sys.R);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t0		= 0;
tend	= 2;
x0 = [0 0 -1 -1];

options = odeset('RelTol',1e-3,'MaxStep',1e-3);

[t x] = ode45(@smd_model, [t0, tend], x0, options, sys);



figure
plot(t,x,'LineWidth',2);
legend('x_1','x_2');

figure
plot(x(:,1),x(:,2));
xlabel('position');
ylabel('velocity');






