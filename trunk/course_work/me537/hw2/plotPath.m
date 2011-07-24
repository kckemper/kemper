function plotPath( results )


figure
title(['Path: ' num2str(results.nC) ' cities']);
plot(results.Cx,results.Cy,' .r','markersize',20);

for i =1:length(results.sol)-1
	line( [results.Cx(results.sol(i))  results.Cx(results.sol(i+1))],[results.Cy(results.sol(i)) results.Cy(results.sol(i+1))] )
	text(  results.Cx(results.sol(i)), results.Cy(results.sol(i))-40, num2str(i-1),'BackgroundColor','w');
	
end

text( results.Cx(results.sol(i+1)), results.Cy(results.sol(i+1))-40, num2str(i),'BackgroundColor','w');
line( [results.Cx(results.sol(i+1)) results.Cx(results.sol(1))],[results.Cy(results.sol(i+1)) results.Cy(results.sol(1))] )

xlabel('Distance (light years)');
ylabel('Distance (light years)');
