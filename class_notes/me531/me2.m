close all
clear all

A = [-5 -4 0; 1 0 0; 0 1 0];
B = [1;0;0];
C =[0 0 1];
D = 0;

Ts = 2;

wn = 1;

sys = tf(wn^3,[1 1.75*wn 2.15*wn^2 wn^3]);

figure
hold on

step(sys);

%from step: Ts_sim ~ 8 sec
%
% wm = 8/2 = 4
wn = 8/Ts;


poles = roots([1 1.75*wn 2.15*wn^2 wn^3])

k = place(A,B,poles);
N = inv([A B; C D])*[zeros(1, length(A)) 1]';
Nx = N(1:end-1);
Nu = N(end);
Nbar = Nu+k*Nx;
syscal2 =  ss(A-B*k,B*Nbar,C,D);
step(syscal2);