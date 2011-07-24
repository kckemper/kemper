#include <stdio.h>
#include <ode/ode.h>
#include <ros/ros.h>
#include <visualization_msgs/Marker.h>

const double PI = 3.141592;

class DiffDriveRobot {

	private:

		static const dReal body_length = 0.2;
		static const dReal body_width = 0.1;
		static const dReal body_height = 0.1;
		static const dReal body_mass_value = 5.0;
		static const dReal front_wheel_radius = 0.025;
		static const dReal front_wheel_width = 0.02;
		static const dReal front_wheel_xoffset = 0.05;
		static const dReal front_wheel_yoffset = 0.07;
		static const dReal front_wheel_zoffset = -0.04;
		static const dReal front_wheel_mass_value = 0.25;
		static const dReal rear_wheel_radius = 0.02;
		static const dReal rear_wheel_xoffset = -0.07;
		static const dReal rear_wheel_zoffset = -0.045;
		static const dReal rear_wheel_mass_value = 0.1;
		static const dReal camera_height = 0.075;

		dBodyID body;
		dBodyID left_wheel;
		dBodyID right_wheel;
		dBodyID rear_wheel;

		dMass* body_mass;
		dMass* front_wheel_mass;
		dMass* rear_wheel_mass;
	
		dJointGroupID joint_group;

		dJointID left_axle;
		dJointID right_axle;
		dJointID rear_axle;

		dGeomID body_geom;
		dGeomID left_wheel_geom;
		dGeomID right_wheel_geom;
		dGeomID rear_wheel_geom;

		ros::NodeHandle n;

		ros::Publisher publisher;

		visualization_msgs::Marker body_msg;
		visualization_msgs::Marker left_wheel_msg;
		visualization_msgs::Marker right_wheel_msg;
		visualization_msgs::Marker rear_wheel_msg;

	public:
		
		DiffDriveRobot(ros::NodeHandle, int, dWorldID, dSpaceID, dReal, dReal, dReal);

		void draw();
		void printLocation();
		void torqueBody(float);
		void torqueLeftWheel(float);
		void torqueRightWheel(float);

};
