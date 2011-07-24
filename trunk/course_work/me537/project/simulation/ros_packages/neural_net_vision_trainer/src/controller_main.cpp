#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#include <opencv/cv.h>
#include <opencv/highgui.h>

#include <ros/ros.h>
#include <sensor_msgs/Image.h>
#include <cv_bridge/CvBridge.h>
#include <image_transport/image_transport.h>

#include <boost/thread.hpp>
#include <boost/format.hpp>

#ifdef HAVE_GTK
	#include <gtk/gtk.h>

	static void destroy(GtkWidget *widget, gpointer data)
	{
		ros::shutdown();
	}
#endif

#include "teleop.h"

#ifndef _REENTRANT
	#error ACK! You need to compile with _REENTRANT defined since this uses threads
#endif

#define QUIT_KEY_PRESS 8

volatile bool bStop = FALSE;

char last_command;

class ImageView
{
private:
  image_transport::Subscriber sub_;
  
  sensor_msgs::ImageConstPtr last_msg_;
  sensor_msgs::CvBridge img_bridge_;
  boost::mutex image_mutex_;
  
  std::string window_name_;
  boost::format image_filename_format_;
  int count_;

public:
	ImageView();
  ImageView(const ros::NodeHandle& nh, const std::string& transport)
    : image_filename_format_(""), count_(0)
  {
    std::string topic = nh.resolveName("image");
    ros::NodeHandle local_nh("~");
    local_nh.param("window_name", window_name_, topic);

    bool autosize;
    local_nh.param("autosize", autosize, false);
    
    std::string format_string;
    local_nh.param("image_filename_format", format_string, std::string("/home/koepld/Desktop/me537/coffeemachine/project/simulation/training_data/images/image%010u.jpg"));
    image_filename_format_.parse(format_string);

    const char* name = window_name_.c_str();
    cvNamedWindow(name, autosize ? CV_WINDOW_AUTOSIZE : 0);
    cvSetMouseCallback(name, &ImageView::mouse_cb, this);
		#ifdef HAVE_GTK
				GtkWidget *widget = GTK_WIDGET( cvGetWindowHandle(name) );
				g_signal_connect(widget, "destroy", G_CALLBACK(destroy), NULL);
		#endif
    cvStartWindowThread();

    image_transport::ImageTransport it(nh);
    sub_ = it.subscribe(topic, 1, &ImageView::image_cb, this, transport);
  }

  ~ImageView()
  {
    cvDestroyWindow(window_name_.c_str());
  }

  void image_cb(const sensor_msgs::ImageConstPtr& msg)
  {
    boost::lock_guard<boost::mutex> guard(image_mutex_);
    
    // Hang on to message pointer for sake of mouse_cb
    last_msg_ = msg;

    // May want to view raw bayer data
    // NB: This is hacky, but should be OK since we have only one image CB.
    if (msg->encoding.find("bayer") != std::string::npos)
      boost::const_pointer_cast<sensor_msgs::Image>(msg)->encoding = "mono8";

    if (img_bridge_.fromImage(*msg, "bgr8"))
      cvShowImage(window_name_.c_str(), img_bridge_.toIpl());
    else
      ROS_ERROR("Unable to convert %s image to bgr8", msg->encoding.c_str());
  }

	bool takePicture() {
    boost::lock_guard<boost::mutex> guard(image_mutex_);

		IplImage *image = img_bridge_.toIpl();
		if (image) {
		  std::string filename = (image_filename_format_ % count_).str();
		  cvSaveImage(filename.c_str(), image);
		  count_++;
			return TRUE;
		} else {
		  ROS_WARN("Couldn't save image, no data!");
			return FALSE;
  	}
	}
};

void *keyboardListenerThread(void *data) {
  TeleopPR2Keyboard tpk;
  tpk.init();
	signal(SIGINT,quit);
	while (!bStop) {
  	last_command = tpk.keyboardRespond();
		if (last_command == QUIT_KEY_PRESS) {
			printf("Stopping threads.\n");
			bStop = TRUE;
		}
		pthread_yield();
	}

	pthread_exit(NULL);
}

void *dataSaverThread(void *data) {
	int i;
	ImageView *view = (ImageView*)data;
	FILE *fp = fopen("/home/koepld/Desktop/me537/coffeemachine/project/simulation/training_data/commands/commandlist.dat", "w");

	while (!bStop) {
		if (view[0].takePicture()) {
			fprintf(fp, "%u\n", last_command);
		}
		for (i = 0; i < 250000; i++) {
			pthread_yield();
		}
	}

	fclose(fp);
	pthread_exit(NULL);
}

int main(int argc, char **argv)
{
	pthread_t keyboard_thread_id;
	pthread_t data_saver_thread_id;

	ros::init(argc, argv, "neuralnet_vision_controller", ros::init_options::AnonymousName);
	ros::NodeHandle n;

	if (n.resolveName("image") == "/image") {
	  ROS_WARN("image_view: image has not been remapped! Typical command-line usage:\n"
	           "\t$ ./image_view image:=<image topic> [transport]");
	}

	ImageView view(n, "raw");

	pthread_create(&keyboard_thread_id, NULL, keyboardListenerThread, NULL);
	pthread_create(&data_saver_thread_id, NULL, dataSaverThread, (void*)&view);

	ros::spin();

  return 0;
}
