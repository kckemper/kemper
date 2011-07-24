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

class TeleopPR2Keyboard
{
  private:
  double walk_vel, run_vel, yaw_rate, yaw_rate_run;
  geometry_msgs::Twist cmd;

  ros::NodeHandle n_;
  ros::Publisher vel_pub_;

  public:
  void init()
  { 
    cmd.linear.x = cmd.linear.y = cmd.angular.z = 0;

    vel_pub_ = n_.advertise<geometry_msgs::Twist>("cmd_vel", 1);

    ros::NodeHandle n_private("~");
    n_private.param("walk_vel", walk_vel, 0.5);
    n_private.param("run_vel", run_vel, 1.0);
    n_private.param("yaw_rate", yaw_rate, 1.0);
    n_private.param("yaw_run_rate", yaw_rate_run, 1.5);

  }
  
  ~TeleopPR2Keyboard()   { }
  void keyboardLoop();

};

int kfd = 0;
struct termios cooked, raw;

void quit(int sig)
{
  tcsetattr(kfd, TCSANOW, &cooked);
  exit(0);
}

int main(int argc, char** argv)
{
  ros::init(argc, argv, "pr2_base_keyboard");

  TeleopPR2Keyboard tpk;
  tpk.init();

  signal(SIGINT,quit);

  tpk.keyboardLoop();

  return(0);
}

void TeleopPR2Keyboard::keyboardLoop()
{
  char c;
  bool dirty=false;

  // get the console in raw mode
  tcgetattr(kfd, &cooked);
  memcpy(&raw, &cooked, sizeof(struct termios));
  raw.c_lflag &=~ (ICANON | ECHO);
  // Setting a new line, then end of file
  raw.c_cc[VEOL] = 1;
  raw.c_cc[VEOF] = 2;
  tcsetattr(kfd, TCSANOW, &raw);

  puts("Reading from keyboard");
  puts("---------------------------");
  puts("Use 'WASD' to translate");
  puts("Use 'QE' to yaw");
  puts("Press 'Shift' to run");

	cmd.linear.x = walk_vel;
	cmd.linear.y = cmd.angular.z = 0;

  for(;;)
  {
    // get the next event from the keyboard
    if(read(kfd, &c, 1) < 0)
    {
      perror("read():");
      exit(-1);

    }

    switch(c)
    {
    case KEYCODE_A:
      cmd.angular.z = 2.;
      dirty = true;
      break;
    case KEYCODE_S:
      cmd.angular.z = 1.;
      dirty = true;
      break;
    case KEYCODE_D:
      cmd.angular.z = 0.5;
      dirty = true;
      break;
    case KEYCODE_F:
      cmd.angular.z = 0.;
      dirty = true;
      break;
    case KEYCODE_J:
      cmd.angular.z = 0.;
      dirty = true;
      break;
    case KEYCODE_K:
      cmd.angular.z = -0.5;
      dirty = true;
      break; 
    case KEYCODE_L:
      cmd.angular.z = -1.0;
      dirty = true;
      break;
    case KEYCODE_SEMI:
      cmd.angular.z = -2.0;
      dirty = true;
      break;
    }

//		cmd.angular.z = min(3., max(-3., cmd.angular.z));
    
    if (dirty == true)
    {
      vel_pub_.publish(cmd);
    }


  }
}
