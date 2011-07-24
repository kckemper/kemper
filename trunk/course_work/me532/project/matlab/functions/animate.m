function [] = animate( sys, step, delay )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

size_b		= 1;															% body size
x			= 0;
l_spring	= sys.parms.dlim;												% displayed spring length

win			= (sys.parms.alim+sys.parms.dlim)*4;

offset		= -(sys.parms.alim+sys.parms.dlim);

fig = figure('position',[10 10 500 500]);
a1 = gca;
hold off


set(a1,'xlim', [-win/2 win/2], 'ylim', [offset win+offset]);

body.x		= sys.t*x;
body.y		= sys.x(:,3)+l_spring;

act.x		= sys.t*x;
act.y		= sys.x(:,1);

spring.x1	= act.x;
spring.y1	= act.y;
spring.x2	= act.x;

spring.y2	= act.y+l_spring;
for i=1:length(sys.t)
	if sys.x(i,3) - sys.x(i,1) < 0
		spring.y2(i)	= body.y(i);
	end
end

% draw the body
H_body	= rectangle('Position',[ body.x(1)-size_b/2		body.y(1)	size_b size_b ], ...
					'FaceColor',[ 0.8 0.8 1]);

% draw the actuator
H_act	= line([x act.x(1)],[-sys.parms.alim act.y(1)],'LineWidth',8,'Color',[0.4 0.9 0.4]);
			
% draw spring
[xdata, ydata] = spring_anim([spring.x1(1), spring.y1(1)], [spring.x2(1), spring.y2(1)], 0.2);
H_spring = line('xdata', xdata, 'ydata', ydata);



% draw the ground
line([-win/4,win/4],[-sys.parms.alim -sys.parms.alim],'LineWidth',4,'Color',[.4 .4 .4]);


% draw the start point
line([-win/4,win/4],[0 0],'LineWidth',1,'Color',[.4 .4 .4]);

% draw text
str	= sprintf('Time: %4.5f', sys.t(1));
t3	= text(-win/2+0.1, offset+0.2, str);

str = sprintf('Max displacement:\n%4.4f m', min(sys.x(:,1)));
t6 = text(-win/2+0.2, win/2-1, str);

if (~isempty(find(sys.evnt.typ==0,1)))
	str = sprintf('Bounced');
	text(-win/2+0.2, win/2-1.40, str);
end

while 1==1
	
	for i=1:step:length(sys.t)

		
		% move the body
		set(H_body,'Position',[ body.x(i)-size_b/2 body.y(i)	size_b size_b ]);
		
		% move the actuator
		set(H_act,'xdata',[x act.x(i)],'ydata',[-sys.parms.alim act.y(i)]);
			
		% move the spring
 		[xdata, ydata] = spring_anim([spring.x1(i), spring.y1(i)], [spring.x2(i), spring.y2(i)], 0.2);
		set(H_spring,'xdata',xdata,'ydata',ydata);


		% draw the time
		str	= sprintf('Time: %4.5f', sys.t(i));
		set(t3, 'string', str);
%		set(t3,'position', [sys.xm(i) y-size_m]);
		
%		set(t4,'position', [sys.xm(i) y+size_m]);
%		set(t5,'position', [sys.xm(i) y+size_m-.5]);
		
%		set(a1,'xlim',[xm(i)-2*size_m xm(i)+window_x-2*size_m]);
		
		pause(delay);
		
	end
		
	pause(2);
%	break;
%	close(fig);
end


end

