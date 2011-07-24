#include <signal.h>
#include <math.h>

#include <ros/ros.h>
#include <geometry_msgs/Twist.h>

#define TRUE 1
#define FALSE 0

class ControlInterface
{
  private:
		double walk_vel, run_vel, yaw_rate, yaw_rate_run;
		geometry_msgs::Twist cmd;

		ros::NodeHandle n_;
		ros::Publisher vel_pub_;

		char last_command;
		volatile bool bStop;

  public:

		void init();
		~ControlInterface(){}

		void sendCommand(char);
		void bumpDetected();
};

void *keyboardListenerThread(void*);
