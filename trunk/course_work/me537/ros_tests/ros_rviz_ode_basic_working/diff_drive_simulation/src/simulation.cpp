#include <stdio.h>
#include <ode/ode.h>
#include <ros/ros.h>
#include <visualization_msgs/Marker.h>

static dWorldID world;
static dSpaceID space;
static dBodyID ball;
static dGeomID ball_geom;

int main( int argc, char** argv )
{
  dMass m;
	const dReal* h;

  //create world
  dInitODE2(0);
  world = dWorldCreate();
  space = dHashSpaceCreate (0);
  dWorldSetGravity (world,0,0,-9.81);

  ros::init(argc, argv, "basic_shapes");
  ros::NodeHandle n;
  ros::Rate r(1000);
  ros::Publisher marker_pub = n.advertise<visualization_msgs::Marker>("visualization_marker", 1);

  // Set our initial shape type to be a cube
  uint32_t shape = visualization_msgs::Marker::CUBE;

	ball = dBodyCreate(world);
	dBodySetPosition(ball, 0., 0., 100.);
	dMassSetBox(&m, 1., 1., 1., 1.);
	dMassAdjust(&m, 1.);
	dBodySetMass(ball, &m);
	ball_geom = dCreateBox(0, 1., 1., 1.);
	dGeomSetBody(ball_geom, ball);

  while (ros::ok())
  {
		h = dBodyGetPosition(ball);
		printf("x = %.3f, y = %.3f, z = %.3f\n", h[0], h[1], h[2]);
		dWorldStep(world, 0.1);

    visualization_msgs::Marker marker;
    // Set the frame ID and timestamp.  See the TF tutorials for information on these.
    marker.header.frame_id = "/my_frame";
    marker.header.stamp = ros::Time::now();

    // Set the namespace and id for this marker.  This serves to create a unique ID
    // Any marker sent with the same namespace and id will overwrite the old one
    marker.ns = "basic_shapes";
    marker.id = 0;

    // Set the marker type.  Initially this is CUBE, and cycles between that and SPHERE, ARROW, and CYLINDER
    marker.type = shape;

    // Set the marker action.  Options are ADD and DELETE
    marker.action = visualization_msgs::Marker::ADD;

    // Set the pose of the marker.  This is a full 6DOF pose relative to the frame/time specified in the header
    marker.pose.position.x = 0;
    marker.pose.position.y = 0;
    marker.pose.position.z = 0;
    marker.pose.orientation.x = 0.0;
    marker.pose.orientation.y = 0.0;
    marker.pose.orientation.z = 0.0;
    marker.pose.orientation.w = 1.0;

    // Set the scale of the marker -- 1x1x1 here means 1m on a side
    marker.scale.x = 1.0;
    marker.scale.y = 1.0;
    marker.scale.z = 1.0;

    // Set the color -- be sure to set alpha to something non-zero!
    marker.color.r = 1.0f;
    marker.color.g = 0.0f;
    marker.color.b = 0.0f;
    marker.color.a = 1.0;

    marker.lifetime = ros::Duration();

    // Publish the marker
    marker_pub.publish(marker);

    // Cycle between different shapes
    switch (shape)
    {
    case visualization_msgs::Marker::CUBE:
      shape = visualization_msgs::Marker::SPHERE;
      break;
    case visualization_msgs::Marker::SPHERE:
      shape = visualization_msgs::Marker::ARROW;
      break;
    case visualization_msgs::Marker::ARROW:
      shape = visualization_msgs::Marker::CYLINDER;
      break;
    case visualization_msgs::Marker::CYLINDER:
      shape = visualization_msgs::Marker::CUBE;
      break;
    }

    r.sleep();
  }
	dGeomDestroy(ball_geom);
  dSpaceDestroy (space);
  dWorldDestroy (world);
  dCloseODE();
}

