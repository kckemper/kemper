clear
close all

fprintf('\n\n\nSTARTING!!\n');

sys.eps	= 0.15;

A = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t0		= 0;
tend	= 20;
x0 = [A 0];

options = odeset('RelTol',1e-3,'MaxStep',1e-3);

[t x] = ode45(@prob3_model, [t0, tend], x0, options, sys);

r = (2*exp(sys.eps*t./2))./(sqrt(exp(sys.eps*t)-(A^2-4)/(A^2)));

y = r.*cos(t)+sys.eps*( ((-11/96)*A^3 + A/2)*cos(t+pi/2) + (1/96)*r.*sin(3*t) );

figure('position',[200 200 400 300]);
title('$A=2$, $\epsilon = 0.15$','interpreter','latex');
hold on
p1 = plot(t,x(:,1),'LineWidth',2);
p2 = plot(t,y,'--r','LineWidth',2);

legend([p1 p2],'y','~y');

xlabel('time (s)');
ylabel('y');

% figure
% hold on
% plot(x(:,1),x(:,2),'LineWidth',2);
% 
% p = plot(x(1,1),x(1,2),'.r','MarkerSize',20);
% legend(p,'start');
% 
% xlabel('position');
% ylabel('velocity');


save2pdf('./images/problem3_4.pdf');



