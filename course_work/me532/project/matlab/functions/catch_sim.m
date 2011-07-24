function [ out ] = catch_sim( sys, model )
%CATCH_SIM Sets up and runs the simulation for stopping a mass
%	Takes a struct as the input with the following members:
%		sys.parms.x0		: intial conditions
%
%		sys.parms.k			: spring constant
%		sys.parms.B			: damping constant
%		sys.parms.mm		: motor mass
%		sys.parms.mL		: load mass
%
%		sys.F				: the forces to apply with the actuator


% set up the initial conditions
t_tmp=0;
x_tmp=sys.parms.x0;

t			= [];
x			= [];

% setup options for ode
options.contact		= odeset('Event',@event,	'RelTol',1e-3,	'MaxStep',1e-3);
options.noncontact	= odeset('Event',@event,	'RelTol',1e-3,	'MaxStep',1e-3);

% init state varables (used to keep track of what model to use for the system
CONTACT = 1;
NON_CONTACT = 0;
flag = 0;

state = CONTACT;			% start state
evnt.t		= [];
evnt.typ	= [state];



while t_tmp(end) < sys.tF(end)

	if state==CONTACT
		
		if model == 0
			[t_tmp,x_tmp,t_evt,foo,i_evt] = ode45(@contact_model,	[t_tmp(end), sys.tF(end)],	x_tmp(end,:),	options.contact, sys);
			
		elseif model == 1
			[t_tmp,x_tmp,t_evt,foo,i_evt] = ode45(@nonlin_contact_model,	[t_tmp(end), sys.tF(end)],	x_tmp(end,:),	options.contact, sys);
			
		elseif model == 2
			[t_tmp,x_tmp,t_evt,foo,i_evt] = ode45(@lim_contact_model,	[t_tmp(end), sys.tF(end)],	x_tmp(end,:),	options.contact, sys);
			
		elseif model == 3
			[t_tmp,x_tmp,t_evt,foo,i_evt] = ode45(@nonlin_lim_contact_model,	[t_tmp(end), sys.tF(end)],	x_tmp(end,:),	options.contact, sys);
		end

		try
			t_evt = t_evt(end);
			i_evt = i_evt(end);
		catch exception
			t_evt = 0;
			i_evt = 0;
		end


% 			fprintf('t %1.3f :\t typ %1.0f :\t i_evt %1.0f\n\n',t_evt, CONTACT, i_evt);
% 			pause(1);

		if i_evt >= 2		% if the load hits the ground...
			evnt.t		= [evnt.t; t_evt];
			evnt.typ	= [evnt.typ; i_evt];
			t = [t; t_tmp];
			x = [x; x_tmp];
			flag = 1;
%				fprintf('actuator crashed\n');
			break;
		end
		if t_tmp(end) ~= sys.tF(end)
			evnt.t		= [evnt.t; t_evt];
			evnt.typ	= [evnt.typ; NON_CONTACT];
			state		= NON_CONTACT;
%				fprintf('lost contact: t %1.3f, typ %d, i_evt %d\n',evnt.t(end),evnt.typ(end),i_evt);
		end
	else
		
		if model < 2
			[t_tmp,x_tmp,t_evt,foo,i_evt] = ode45(@noncontact_model,	[t_tmp(end), sys.tF(end)],	x_tmp(end,:),	options.noncontact, sys);
		else
			[t_tmp,x_tmp,t_evt,foo,i_evt] = ode45(@lim_noncontact_model,	[t_tmp(end), sys.tF(end)],	x_tmp(end,:),	options.noncontact, sys);
		end

		try
			t_evt = t_evt(end);
			i_evt = i_evt(end);
		catch exception
			t_evt = 0;
			i_evt = 0;
		end


% 			fprintf('t %1.3f :\t typ %1.0f :\t i_evt %1.0f\n\n',t_evt, NON_CONTACT, i_evt);
% 			pause(1);

		if i_evt >= 2		% if the load hits the ground...
			evnt.t		= [evnt.t; t_evt];
			evnt.typ	= [evnt.typ; i_evt];
			flag = 1;
			t = [t; t_tmp];
			x = [x; x_tmp];
%				fprintf('actuator crashed\n');
			break;
		end
		if t_tmp(end) ~= sys.tF(end)
			evnt.t		= [evnt.t; t_evt];
			evnt.typ	= [evnt.typ; CONTACT];
			state		= CONTACT;
%				fprintf('made contact: t %1.3f, typ %d, i_evt %d\n',evnt.t(end),evnt.typ(end),i_evt);
		end
	end
	
	
	t = [t; t_tmp];
	x = [x; x_tmp];

end
	



[foo ind]		= unique(t);
out.t			= t(ind);
out.x			= x(ind, :);
out.evnt		= evnt;



end

