% Ball and beam problem solution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part (a) - Full-state feedback controller design
% Define system matrices
A = [0 1 0 0; 0 0 3.77 0; 0 0 0 1; -5.17 0 0 -105.1];
B = [0; 0; 0; 16.85];
C = [1 0 0 0];
D = 0;
% Check controllability
cmatrix = ctrb(A,B);
disp('The rank of the controllability matrix is:');
disp(rank(cmatrix));
% Rank of controllability matrix is 4 (i.e. full rank).  The system is
% controllable and we can place the poles of the closed loop system
% anywhere we please.  Specifically, we want to determine values for the 
% poles so that they match a Bessel polynomial system with a settling time
% of 2 seconds.  Pull the pole locations from the table and divide by the 
% desired settling time.
poles = [-4.0156 + 5.0723*i -4.0156 - 5.0723*i -5.5281+1.6553*i -5.5281-1.6553*i]/2;
% Find the gain vector that will achieve these poles in closed-loop.
k = place(A,B,poles);
% Compute Nbar to ensure that we have zero steady state error in response
% to a step command change in the ball position.
N = inv([A B; C D])*[zeros(1,length(A)) 1]';
Nx = N(1:end-1);
Nu = N(end);
Nbar = Nu + k*Nx;
% Create the closed-loop system.
syscl = ss(A-B*k,B*Nbar,C,D);
% Simulate the response for a commanded change in position of 0.25 m, with
% initial conditions r = .025, theta = 2/180*pi
%step(syscl);
tstart = 0:.001:3;
rstart = .25*ones(size(tstart));
[yparta,tparta,xparta] = lsim(syscl,rstart,tstart,[.025; 0; 2/180*pi; 0]);
f1 = figure;
plot(tparta,yparta); hold on; grid on;
xlabel('Time (s)');
ylabel('Ball position (m)');
%print -djpeg90 2010ME531HW2Prob3a.jpg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part (b) - Tracking Controller Design
% Relative degree of system is gamma = 4 (C*A^3*B <> 0)
den = C*A^3*B;
coeff = C*A^4;
% Place poles of error dynamics at -8,-10,-12,-14 (significantly faster
% than the frequency of the signal we are trying to track).  Create the
% characteristic equation governing the error dynamics with these poles and
% identify the alpha coefficients from the characteristic equation.
errorcharacteristic = conv([1 8],conv(conv([1 10],[1 12]),[1 14]));
alpha3 = errorcharacteristic(2);
alpha2 = errorcharacteristic(3);
alpha1 = errorcharacteristic(4);
alpha0 = errorcharacteristic(5);
% Create parts of our new A matrix with control
errordynmat = [0 1 0 0; 0 0 1 0; 0 0 0 1; -alpha0 -alpha1 -alpha2 -alpha3];
topleft = A - B(4)/den*[0 0 0 0; 0 0 0 0; 0 0 0 0; coeff(1) coeff(2) coeff(3) coeff(4)];
topright = B(4)/den*[0 0 0 0; 0 0 0 0; 0 0 0 0; alpha0 alpha1 alpha2 alpha3];
bottomleft = zeros(4,4);
Anew = [topleft topright; bottomleft errordynmat];
Bnew = [B; 0; 0; 0; 0];
Cnew = [C 0 0 0 0];
Dnew = D;
% Form the closed loop system with tracking control
syscltrack = ss(Anew,Bnew,Cnew,Dnew);
t = 0:.001:4*pi;
u = sin(t)/den;
% Initial conditions for states
x0 = [.025; 0; 2/180*pi; 0];
% Initial conditions for error dynamics
ic = [0; 1; 0; -1] - [.025; C*A*x0; C*A^2*x0; C*A^3*x0];
% Simulate system dynamics and error dynamics from initial conditions
y = lsim(syscltrack,u,t,[.025; 0; 2/180*pi; 0; ic]);
f2 = figure;
plot(t,y,'b'); hold on; grid on;
plot(t,sin(t),'g--');
xlabel('Time (s)');
ylabel('Ball position (m)');
%print -djpeg90 2010ME531HW2Prob3b.jpg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part (c) - Full-order estimator design
% Place estimator poles 5-10 times faster than desired pole locations. j
% From trial and error, I found that I had to place them even faster than
% that to get good performance.
Gtrans = place(A',C',[-50 -60 -70 -80]);
G = Gtrans';
% Create new A, B, C and D matrices with both control and estimator
% included
Aplusest = [A -B*k; G*C A-B*k-G*C];
Bplusest = [B*Nbar; B*Nbar];
Cplusest = [C zeros(1,4); zeros(1,4) C];
Dplusest = [0; 0];
% Create the system from our state space matrices
sysclest = ss(Aplusest,Bplusest,Cplusest,Dplusest);
tnew = 0:.001:4;
unew = .25*ones(size(tnew));
% Simulate the system response.  Note that the initial conditions for the
% estimated states are unknown, so just assume that they are zero.
[ycl,tcl,xcl] = lsim(sysclest,unew,tnew,[.025; 0; 2/180*pi; 0; 0; 0; 0; 0]);
f3 = figure;
% Plot output
plot(tcl,ycl(:,1),'b'); hold on; grid on;
% Plot state estimate as well
plot(tcl,xcl(:,5),'r--');
xlabel('Time (s)');
ylabel('Ball position (m)');
%print -djpeg90 2010ME531HW2Prob3c.jpg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%