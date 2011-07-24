function [value,isterminal,direction] = contact_event(t, x, sys)      
	% Setup event detection (contact/noncontact)
	value = [x(3)-x(1)];
	isterminal = [1];
	direction = [0];
end

