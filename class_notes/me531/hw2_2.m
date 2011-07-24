close all

fprintf('Problem 2\n');

A = [-2 1 0; 0 -1 1; 0 -1 -2];
B = [0; 0; 1];
C = [1 0 0];
D = [0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Problem 2a:
fprintf('\ta)\n');

cMat = [B A*B A^2*B];
cMatInv = cMat^-1;

P2a = [-2 -1+1j -1-1j];

K2a = place(A,B,P2a)


fprintf('\tb)\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Problem 2bi:
fprintf('\t\ti)\n');

Pi = [-100 -0.889+1.1213*j -0.889-1.1213*j];

Ki = place(A,B,Pi);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Problem 2bii:
fprintf('\t\tii)\n');

Ts = 4.5;

p1 = -5.0093/Ts;
p2 = (-3.9668 + 3.7845*i)/Ts;
p3 = (-3.9668 - 3.7845*i)/Ts;

Pii = [p1 p2 p3];

Kii = place(A,B,Pii)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Problem 2biii:
fprintf('\t\tiii)\n');

Ts = 4.5;
wn = 1;
sys = tf(wn^3,[1 1.75*wn 2.15*wn^2 wn^3]);

%figure
%step(sys);

%from step: Ts_sim ~ 8 sec
% wm = 8/2 = 4
wn = 8/Ts;

Piii = roots([1 1.75*wn 2.15*wn^2 wn^3])
Kiii = place(A,B,Piii)



colors = brighten(lines(3),0.5); % jet() hsv() lines()
figure
hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Problem 2ci:

N = inv([A B; C D])*[zeros(1, length(A)) 1]';
Nx = N(1:end-1);
Nu = N(end);
Nbar = Nu+Ki*Nx;
syscal_i =  ss(A-B*Ki,B*Nbar,C,D);

stepplot(syscal_i,'b');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Problem 2cii:

N = inv([A B; C D])*[zeros(1, length(A)) 1]';
Nx = N(1:end-1);
Nu = N(end);
Nbar = Nu+Kii*Nx;
syscal_ii =  ss(A-B*Kii,B*Nbar,C,D);

stepplot(syscal_ii,'r');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Problem 2ciii:

N = inv([A B; C D])*[zeros(1, length(A)) 1]';
Nx = N(1:end-1);
Nu = N(end);
Nbar = Nu+Kiii*Nx;
syscal_iii =  ss(A-B*Kiii,B*Nbar,C,D);

stepplot(syscal_iii,'g');


plot([0 7],[1.1 1.1],'k')
legend('second order approx', 'Bessel', 'ITAE', '10% over','Location','SouthEast');
%save2pdf('./hw2_2c.pdf')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Problem 2d:


a0 = 6;
a1 = 11;
a2 = 6;

A = [	-2 1 0 0   0   0;
		0 -1 1 0   0   0;
		-8 5 -5 -a0  -a1  -a2;
		0  0 0 0   1   0;
		0  0 0 0   0   1;
		0  0 0 -a0 -a1 -a2];

B = [0;0;1;0;0;0];
C = [1,0,0,0,0,0];
D = [0];

t = linspace(0,10,1e4);
yd = 10*cos(t);

sys =  ss(A,B,C,D);

figure
hold on
plot(t,sin(t));
[Y,T,X] = lsim(sys,yd,t,[2 1 0 -2 1 0]);
plot(t,Y(:,1));


save2pdf('./hw2_2d.pdf')