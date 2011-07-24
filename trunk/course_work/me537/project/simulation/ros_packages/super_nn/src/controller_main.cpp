#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#include "teleop.h"
#include "cam_view.h"
#include "evo_supervised_learner.h"

#ifndef _REENTRANT
	#error ACK! You need to compile with _REENTRANT defined since this uses threads
#endif

void *learnerThread(void *data) {
	int i;
	CamView* view = (CamView*)data;
	pthread_t keyboard_thread_id;
	TeleopPR2Keyboard tpk;
	EvoSupervisedLearner* learner = (EvoSupervisedLearner*)malloc(sizeof(EvoSupervisedLearner));
	IplImage* image = (IplImage*)malloc(sizeof(IplImage));

	pthread_create(&keyboard_thread_id, NULL, keyboardListenerThread, (void*)&tpk);

	*learner = EvoSupervisedLearner();
	learner->initialize(0);

	while (!tpk.getBStop()) {
		image = view->grabPicture();
		if (image != NULL) {
			learner->learn(image, tpk.getLastCommand());
		}

		for (i = 0; i < 250000; i++) {
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

	CamView view(n, "raw");

	pthread_create(&learner_thread_id, NULL, learnerThread, (void*)&view);

	ros::spin();

  return 0;
}
