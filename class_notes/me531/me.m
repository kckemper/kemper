A = [-5 -4 0; 1 0 0; 0 1 0];
B = [1;0;0];
C =[0 0 1];
D = 0;

Ts = 2;

p1 = -5.0093/Ts;
p2 = (-3.9668 + 3.7845*i)/Ts;
p3 = (-3.9668 - 3.7845*i)/Ts;

k = place(A,B,[p1 p2 p3]); 
N = inv([A B; C D])*[zeros(1, length(A)) 1]';
Nx = N(1:end-1);
Nu = N(end);
Nbar = Nu+k*Nx;
syscal =  ss(A-B*k,B*Nbar,C,D);
step(syscal);