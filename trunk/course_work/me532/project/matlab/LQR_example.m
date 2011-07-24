close all
clear all

A = [0		1			0			0;...
	 0		-0.1818		2.6727		0;...
	 0		0			0			1;...
	 0		-0.4545		31.1818		0];

B = [0; 1.8182; 0; 4.5455];

C = [1 0 0 0; 0 0 1 0];

D = 0;


Q = eye(4);
R = eye(1);

Q(1,1)=200;
Q(2,2)=1;
Q(3,3)=100;
Q(4,4)=1;

[K,P,e] = lqr(A,B,Q,R);

N = inv([A,B; C(1,:),D])*[zeros(1,length(A)) 1]';

Nx = N(1:end-1);
Nu = N(end);
Nbar = Nu+K*Nx;

Acl = A-B*K;
Bcl = B*Nbar;


syscl =  ss(Acl,Bcl,C,0);


X0 = [ 0; 0; 0; 0];

t = 0:0.001:3;
r = ones(length(t),1)*0.5;


[Y,t,X] = lsim(syscl,r,t,X0);

plot(X);