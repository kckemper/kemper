close all
clear all

% x1 = zeros(size(u));
% x2 = (1+sqrt(1+4*u))/2;
% x3 = (1-sqrt(1+4*u))/2;
% x4 = sqrt(-1+u);
% x5 = -sqrt(-1+u);



u = -1/8;
x = (1+sqrt(1+4*u))/2;
eig = u - u^2 + 2*x - 2*u*x - 3*x^2 + 6*u*x^2 + 4*x^3 - 5*x^4;
fprintf('\nu=%1.4f, x=%1.4f : eig= %1.4f\n',u,x,eig);

u = -1/8;
x = (1-sqrt(1+4*u))/2;
eig = u - u^2 + 2*x - 2*u*x - 3*x^2 + 6*u*x^2 + 4*x^3 - 5*x^4;
fprintf('\nu=%1.4f, x=%1.4f : eig= %1.4f\n',u,x,eig);

u = -1/8;
x = 0;
eig = u - u^2 + 2*x - 2*u*x - 3*x^2 + 6*u*x^2 + 4*x^3 - 5*x^4;
fprintf('\nu=%1.4f, x=%1.4f : eig= %1.4f\n',u,x,eig);


u = 1/2;
x = 0;
eig = u - u^2 + 2*x - 2*u*x - 3*x^2 + 6*u*x^2 + 4*x^3 - 5*x^4;
fprintf('\nu=%1.4f, x=%1.4f : eig= %1.4f\n',u,x,eig);

u = 1/2;
x = (1-sqrt(1+4*u))/2;
eig = u - u^2 + 2*x - 2*u*x - 3*x^2 + 6*u*x^2 + 4*x^3 - 5*x^4;
fprintf('\nu=%1.4f, x=%1.4f : eig= %1.4f\n',u,x,eig);


u = 3/2;
x = sqrt(-1+u);
eig = u - u^2 + 2*x - 2*u*x - 3*x^2 + 6*u*x^2 + 4*x^3 - 5*x^4;
fprintf('\nu=%1.4f, x=%1.4f : eig= %1.4f\n',u,x,eig);

u = 3/2;
x = 0;
eig = u - u^2 + 2*x - 2*u*x - 3*x^2 + 6*u*x^2 + 4*x^3 - 5*x^4;
fprintf('\nu=%1.4f, x=%1.4f : eig= %1.4f\n',u,x,eig);

u = 3/2;
x = -sqrt(-1+u);
eig = u - u^2 + 2*x - 2*u*x - 3*x^2 + 6*u*x^2 + 4*x^3 - 5*x^4;
fprintf('\nu=%1.4f, x=%1.4f : eig= %1.4f\n',u,x,eig);


u = 5/2;
x = sqrt(-1+u);
eig = u - u^2 + 2*x - 2*u*x - 3*x^2 + 6*u*x^2 + 4*x^3 - 5*x^4;
fprintf('\nu=%1.4f, x=%1.4f : eig= %1.4f\n',u,x,eig);

u = 5/2;
x = -sqrt(-1+u);
eig = u - u^2 + 2*x - 2*u*x - 3*x^2 + 6*u*x^2 + 4*x^3 - 5*x^4;
fprintf('\nu=%1.4f, x=%1.4f : eig= %1.4f\n',u,x,eig);

u = 5/2;
x = (1-sqrt(1+4*u))/2;
eig = u - u^2 + 2*x - 2*u*x - 3*x^2 + 6*u*x^2 + 4*x^3 - 5*x^4;
fprintf('\nu=%1.4f, x=%1.4f : eig= %1.4f\n',u,x,eig);

