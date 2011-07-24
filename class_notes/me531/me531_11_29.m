clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Design a regulator

Tsdes = 0.5;

A = [0 1 0; 980 0 -2.8; 0 0 -100];
B = [0;0;100];
C =[1 0 0];
D = 0;

eig(A)

cmat = ctrb(A,B);
rank(cmat);

wn = 1;
sys = tf(wn^3,[1 1.75*wn 2.15*wn^2 wn^3]);
%figure
%step(sys);

% actual settling time for wn=1 is Ts~8 sec.
Ts=8;
wndes1 = (wn*Ts)/Tsdes;
wndes2 = 2*(wn*Ts)/Tsdes;

poles1 = roots([1 1.75*wndes1 2.15*wndes1^2 wndes1^3]);
poles2 = roots([1 1.75*wndes2 2.15*wndes2^2 wndes2^3]);

poles = poles2; % we'll use these poles for later...

K1 = place(A,B,poles1);
K2 = place(A,B,poles2);

syscl1 =  ss(A-B*K1,B,C,D);
syscl2 =  ss(A-B*K2,B,C,D);


t = 0:0.001:3;
r = zeros(size(t));	% ref to 0

[y1,t1,x1] = lsim (syscl1,r,t,[0.005;0;0]);
[y2,t2,x2] = lsim (syscl2,r,t,[0.005;0;0]);


%figure
%plot(t1,y1,t2,y2);
%legend('\omega_n=16','\omega_n=32');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K3 = place(A,B,poles2);

t = 0:0.001:3;
r = 0.001*ones(size(t));	% ref to 0.001

N = inv([A B; C D])*[zeros(1, length(A)) 1]';
Nx = N(1:end-1);
Nu = N(end);
Nbar = Nu+K3*Nx;

syscl3 =  ss(A-B*K3,B*Nbar,C,D);

[y3,t3,x3] = lsim (syscl3,r,t,[0.005;0;0]);

%figure
%plot(t3,y3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Design a full order estimator

K = place(A,B,poles);
% check observability
omat = obsv(A,C);
rank(omat);

Ke = place(A',C',[-85 -90 -95]);

G = Ke';

Acl = [A-B*K B*K; zeros(size(A)) A-G*C];
% check eigenvalues
eig(Acl)

Bcl = [B*Nbar; 0; 0; 0];
Ccl = [C 0 0 0; C -C];
D = [0;0];

syscl = ss(Acl,Bcl,Ccl,D);
[ycl,tcl,xcl] = lsim(syscl,r,t,[0; 0.01; 0; 0; 0.01; 0]);  % ~x = x-^x

figure
% h
plot(tcl,xcl(:,1));

figure
% error
plot(tcl,xcl(:,4));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Design a reduced order estimator

App = 0;
Apr = [1 0];
Arp = [980; 0];
Arr = [0,-2.8;0,-100];
Bp = 0;
Br = [0;100];

Kre = place(Arr',Apr',[-90 -95]);
G = Kre';

%[t,y] = ode45('testsimred2',[0 1],[0;0.01;0;0;0]);
%plot(t,y(:,1))

