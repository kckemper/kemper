#include "teleop.h"

int kfd = 0;
struct termios cooked, raw;

void TeleopPR2Keyboard::init()
{ 
	bStop = FALSE;

  cmd.linear.x = cmd.linear.y = cmd.angular.z = 0;

  vel_pub_ = n_.advertise<geometry_msgs::Twist>("cmd_vel", 1);

  ros::NodeHandle n_private("~");
  n_private.param("walk_vel", walk_vel, 0.5);
  n_private.param("run_vel", run_vel, 1.0);
  n_private.param("yaw_rate", yaw_rate, 1.0);
  n_private.param("yaw_run_rate", yaw_rate_run, 1.5);

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

	cmd.linear.x = walk_vel;
	cmd.linear.y = cmd.angular.z = 0;

	vel_pub_.publish(cmd);
}

void TeleopPR2Keyboard::keyboardRespond() {
  char c;
  bool dirty = FALSE;

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
    dirty = TRUE;
		last_command = 0;
    break;
  case KEYCODE_S:
    cmd.angular.z = 1.;
    dirty = TRUE;
		last_command = 1;
    break;
  case KEYCODE_D:
    cmd.angular.z = 0.5;
    dirty = TRUE;
		last_command = 2;
    break;
  case KEYCODE_F:
    cmd.angular.z = 0.;
    dirty = TRUE;
		last_command = 3;
    break;
  case KEYCODE_J:
    cmd.angular.z = 0.;
    dirty = TRUE;
		last_command = 4;
    break;
  case KEYCODE_K:
    cmd.angular.z = -0.5;
    dirty = TRUE;
		last_command = 5;
    break; 
  case KEYCODE_L:
    cmd.angular.z = -1.0;
    dirty = TRUE;
		last_command = 6;
    break;
  case KEYCODE_SEMI:
    cmd.angular.z = -2.0;
    dirty = TRUE;
		last_command = 7;
    break;

	//exit
	case KEYCODE_X:
		cmd.angular.z = 10.;
		dirty = TRUE;
		bStop = TRUE;
		printf("Stopping threads.\n");
		break;
  } 

  if (dirty == TRUE)
  {
    vel_pub_.publish(cmd);
  }
}

char TeleopPR2Keyboard::getLastCommand() {
	return last_command;
}

bool TeleopPR2Keyboard::getBStop() {
	return bStop;
}

void TeleopPR2Keyboard::setBStop(bool val) {
	bStop = val;
}


void quit(int sig)
{
  tcsetattr(kfd, TCSANOW, &cooked);
  exit(0);
}

void *keyboardListenerThread(void *data) {
	TeleopPR2Keyboard* tpk = (TeleopPR2Keyboard*)data;

  tpk->init();
	signal(SIGINT,quit);
	while (!tpk->getBStop()) {
		tpk->keyboardRespond();
		pthread_yield();
	}

	pthread_exit(NULL);
}
