#include <termios.h>
#include <signal.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include <ros/ros.h>
#include <geometry_msgs/Twist.h>

#define KEYCODE_A 0x61
#define KEYCODE_S 0x73
#define KEYCODE_D 0x64
#define KEYCODE_F 0x66
#define KEYCODE_J 0x6A 
#define KEYCODE_K 0x6B
#define KEYCODE_L 0x6C
#define KEYCODE_SEMI 0x3B
#define KEYCODE_X 0x78

class TeleopPR2Keyboard
{
  private:
		double walk_vel, run_vel, yaw_rate, yaw_rate_run;
		geometry_msgs::Twist cmd;

		ros::NodeHandle n_;
		ros::Publisher vel_pub_;

  public:

		void init();

		~TeleopPR2Keyboard(){}
		char keyboardRespond();

};

void quit(int);
