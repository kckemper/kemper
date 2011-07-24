#include "cam_view.h"

#ifdef HAVE_GTK
	#include <gtk/gtk.h>

	static void destroy(GtkWidget *widget, gpointer data)
	{
		ros::shutdown();
	}
#endif

CamView::CamView() {};
CamView::CamView(const ros::NodeHandle& nh, const std::string& transport)
  : image_filename_format_(""), count_(0)
{
  std::string topic = "/cam/image";
  ros::NodeHandle local_nh("~");
  local_nh.param("window_name", window_name_, topic);

  bool autosize;
  local_nh.param("autosize", autosize, false);
  
//  std::string format_string;
//  local_nh.param("image_filename_format", format_string, std::string("/home/drl/Desktop/coffeemachine/project/simulation/training_data/images/image%010u.jpg"));
//  image_filename_format_.parse(format_string);

  const char* name = window_name_.c_str();
  cvNamedWindow(name, autosize ? CV_WINDOW_AUTOSIZE : 0);
	#ifdef HAVE_GTK
			GtkWidget *widget = GTK_WIDGET( cvGetWindowHandle(name) );
			g_signal_connect(widget, "destroy", G_CALLBACK(destroy), NULL);
	#endif
  cvStartWindowThread();

  image_transport::ImageTransport it(nh);
  sub_ = it.subscribe(topic, 1, &CamView::image_cb, this, transport);
}

CamView::~CamView()
{
  cvDestroyWindow(window_name_.c_str());
}

void CamView::image_cb(const sensor_msgs::ImageConstPtr& msg)
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

bool CamView::takePicture() {
  boost::lock_guard<boost::mutex> guard(image_mutex_);

	IplImage *image = img_bridge_.toIpl();
//	if (image) {
//		std::string filename = (image_filename_format_ % count_).str();
//		cvSaveImage(filename.c_str(), image);
//		count_++;
//		return TRUE;
//	} else {
//		ROS_WARN("Couldn't save image, no data!");
//		return FALSE;
//	}
}

IplImage* CamView::grabPicture() {
  boost::lock_guard<boost::mutex> guard(image_mutex_);

	IplImage *image = img_bridge_.toIpl();

	return image;
}
