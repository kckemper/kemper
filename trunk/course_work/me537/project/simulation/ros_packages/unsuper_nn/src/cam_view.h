#include <opencv/cv.h>
#include <opencv/highgui.h>

#include <ros/ros.h>
#include <sensor_msgs/Image.h>
#include <cv_bridge/CvBridge.h>
#include <image_transport/image_transport.h>

#include <boost/thread.hpp>
#include <boost/format.hpp>

class CamView {
	private:
		image_transport::Subscriber sub_;
		
		sensor_msgs::ImageConstPtr last_msg_;
		sensor_msgs::CvBridge img_bridge_;
		boost::mutex image_mutex_;
		
		std::string window_name_;
		boost::format image_filename_format_;
		int count_;

	public:
		CamView();
		CamView(const ros::NodeHandle&, const std::string&);

		~CamView();

		void image_cb(const sensor_msgs::ImageConstPtr&);

		bool takePicture();
		IplImage* grabPicture();
};
