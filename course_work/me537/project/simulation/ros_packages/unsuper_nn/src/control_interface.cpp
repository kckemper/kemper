#include "control_interface.h"

void ControlInterface::init()
{ 
  cmd.linear.x = cmd.linear.y = cmd.angular.z = 0;
	cmd.linear.y = cmd.angular.z = 0;

  vel_pub_ = n_.advertise<geometry_msgs::Twist>("cmd_vel", 1);

  ros::NodeHandle n_private("~");
  n_private.param("walk_vel", walk_vel, 0.5);
  n_private.param("run_vel", run_vel, 1.0);
  n_private.param("yaw_rate", yaw_rate, 1.0);
  n_private.param("yaw_run_rate", yaw_rate_run, 1.5);

	cmd.linear.x = run_vel;

	vel_pub_.publish(cmd);
}

void ControlInterface::sendCommand(char c) {
	switch (c) {
		case 0:
			cmd.angular.z = 2.0;
			break;
		case 1:
			cmd.angular.z = 1.0;
			break;
		case 2:
			cmd.angular.z = 0.5;
			break;
		case 3:
			cmd.angular.z = 0.0;
			break;
		case 4:
			cmd.angular.z = 0.0;
			break;
		case 5:
			cmd.angular.z = -0.5;
			break;
		case 6:
			cmd.angular.z = -1.0;
			break;
		case 7:
			cmd.angular.z = -2.0;
			break;
	}

	vel_pub_.publish(cmd);
}

void ControlInterface::bumpDetected() {
	int i;

	// Put it in reverse.
	cmd.angular.z = 0;
	cmd.linear.x *= -1;
	vel_pub_.publish(cmd);

	// Wait for a while.
	for (i = 0; i < 10000000; i++) {
		pthread_yield();
	}

	// Continue on.
	cmd.linear.x *= -1;
	vel_pub_.publish(cmd);

	// Drive forward for a bit.
	for (i = 0; i < 1000000; i++) {
		pthread_yield();
	}
}
