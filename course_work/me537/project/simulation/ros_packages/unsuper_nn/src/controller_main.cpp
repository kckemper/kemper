#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#include <gazebo_plugins/gazebo_ros_bumper.h>

#include "control_interface.h"
#include "cam_view.h"
#include "evo_unsupervised_learner.h"

#ifndef _REENTRANT
	#error ACK! You need to compile with _REENTRANT defined since this uses threads
#endif

#define COLLISION_PENALTY 1.0

int picture_counter;

bool collision;

void bumperCallback(const gazebo_plugins::ContactsState& msg) {
	collision = TRUE;
}

// Continously save pictures from the robot's camera.
void *recorderThread(void* data) {
	int i;
	const char* filename_format = "/media/shared_space/diff_drive_pictures/robot_cam%010u.jpg";
	char filename[128];	
	CamView* view = (CamView*)data;
	IplImage* image = (IplImage*)malloc(sizeof(IplImage));

	while (TRUE) {
		image = view->grabPicture();

		if ( image ) {
			sprintf(filename, filename_format, picture_counter);
			cvSaveImage(filename, image);
			picture_counter++;
		}

		for (i = 0; i < 10000; i++) {
			pthread_yield();
		}
	}

	pthread_exit(NULL);
}

void *learnerThread(void* data) {
	int i;
	char command = 3;
	pthread_t recorder_thread_id;
	ros::NodeHandle n = *(ros::NodeHandle*)data;
	CamView view(n, "raw");
	ControlInterface control_interface;
	EvoUnsupervisedLearner* learner = (EvoUnsupervisedLearner*)malloc(sizeof(EvoUnsupervisedLearner));
	IplImage* image = (IplImage*)malloc(sizeof(IplImage));

	ros::Subscriber sub = n.subscribe("/bumper/state", 1, bumperCallback);

	// Wait for a good picture from the camera.
	do {
		image = view.grabPicture();
		pthread_yield();
	} while ( !image || (image->width == 0) || (image->width > 10000));

	pthread_create(&recorder_thread_id, NULL, recorderThread, (void*)&view);

	printf("Forked.\n");

	control_interface.init();

	*learner = EvoUnsupervisedLearner(image);
	learner->initialize(0);

	while (TRUE) {
		if (collision) {
			learner->penalize(COLLISION_PENALTY);
			control_interface.bumpDetected();
			collision = FALSE;
		}

		image = view.grabPicture();

		if ( image ) {
			command = learner->takeImage(image, picture_counter);
			switch (command) {
				case 0:
				case 7:
					learner->decayPenalties(1.2);
					break;
				case 1:
				case 6:
					learner->decayPenalties(1.1);
					break;
				case 2:
				case 5:
					learner->decayPenalties(1.01);
					break;
				case 3:
				case 4:
					learner->decayPenalties(0.8);
					break;
			}
			control_interface.sendCommand(command);
		}

		for (i = 0; i < 100000; i++) {
			pthread_yield();
		}
	}

	pthread_exit(NULL);
}

int main(int argc, char **argv)
{
	pthread_t learner_thread_id;

	ros::init(argc, argv, "neuralnet_vision_controller", ros::init_options::AnonymousName);
	ros::NodeHandle n;

	picture_counter = 0;
	collision = FALSE;

	pthread_create(&learner_thread_id, NULL, learnerThread, (void*)&n);

	ros::spin();

  return 0;
}
