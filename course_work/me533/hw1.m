clear all
close all

%prob 5

rs = linspace(-10,10,1e2);
as = linspace(-10,10,1e2);


xsp = zeros(rs,as);
xsn = zeros(rs,as);


for i = 1:length(rs)
	r = rs(i);
	
	for j = 1:length(as)
		a = as(j);
		
		xsp(i,j) = real((-a + sqrt(a^2+4*r))/2);
		xsn(i,j) = real((-a - sqrt(a^2+4*r))/2);
		
	end
	
end

surf(rs,as,xsp);

xlabel('r');
ylabel('a');