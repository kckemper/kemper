function [value,isterminal,direction] = event(t, x, sys)      
	% Setup event detection 
	
	%		 contact	
	value = [x(3)-x(1)];
	isterminal = [1];
	direction = [0];
end