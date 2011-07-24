#include <stdio.h>
#include <ode/ode.h>
#include <ros/ros.h>
#include <visualization_msgs/Marker.h>

#include "diff_drive_robot.h"

#define MAX_TIME 100.
#define MAX_CONTACTS 1000
#define ODE_TIMESTEP 0.0001
#define RVIZ_FPS 50

static float simulation_time;

static dWorldID world;
static dSpaceID space;
static dJointGroupID contact_group;
static dGeomID ground_geom;

// this is called by dSpaceCollide when two objects in space are
// potentially colliding.

static void nearCallback (void *data, dGeomID o1, dGeomID o2)
{
  int i,n;

  //only collide things with the ground
  if (!((o1 == ground_geom) ^ (o2 == ground_geom))) {
		return;
	}

  const int N = 10;
  dContact contact[N];
  n = dCollide (o1,o2,N,&contact[0].geom,sizeof(dContact));
  if (n > 0) {
    for (i=0; i<n; i++) {
      contact[i].surface.mode = dContactSlip1 | dContactSlip2 | dContactSoftERP | dContactSoftCFM | dContactApprox1;
			contact[i].surface.mu = dInfinity;
      contact[i].surface.slip1 = 0.1;
      contact[i].surface.slip2 = 0.1;
      contact[i].surface.soft_erp = 0.5; //0.5;
      contact[i].surface.soft_cfm = 0.3; //0.3;
      dJointID c = dJointCreateContact (world, contact_group, &contact[i]);
      dJointAttach (c,
		    dGeomGetBody(contact[i].geom.g1),
		    dGeomGetBody(contact[i].geom.g2));
    }
  }
}

int main( int argc, char** argv )
{
	int i;
  dMass m;
	
	simulation_time = 0.;

  //create world
  dInitODE2(0);
  world = dWorldCreate();
  space = dHashSpaceCreate (0);
	contact_group = dJointGroupCreate(0);
  dWorldSetGravity (world, 0., 0., -9.81);
//	dWorldSetGravity (world, 0., 0., 0.);

  ros::init(argc, argv, "basic_shapes");
  ros::NodeHandle n;
  ros::Rate r(RVIZ_FPS);
  ros::Publisher ground_pub = n.advertise<visualization_msgs::Marker>("ground", 1);

  visualization_msgs::Marker ground_msg;
	ground_msg.type = visualization_msgs::Marker::CUBE;
  // Set the frame ID and timestamp.  See the TF tutorials for information on these.
  ground_msg.header.frame_id = "/my_frame";
  ground_msg.header.stamp = ros::Time::now();

  // Set the namespace and id for this marker.  This serves to create a unique ID
  // Any marker sent with the same namespace and id will overwrite the old one
  ground_msg.ns = "ground";
  ground_msg.id = 0;

  // Set the marker action.  Options are ADD and DELETE
  ground_msg.action = visualization_msgs::Marker::ADD;

  // Set the pose of the marker.  This is a full 6DOF pose relative to the frame/time specified in the header
  ground_msg.pose.position.x = 0.;
  ground_msg.pose.position.y = 0.;
  ground_msg.pose.position.z = -0.25;
  ground_msg.pose.orientation.x = 0.0;
  ground_msg.pose.orientation.y = 0.0;
  ground_msg.pose.orientation.z = 0.0;
  ground_msg.pose.orientation.w = 1.0;

  // Set the scale of the marker -- 1x1x1 here means 1m on a side
  ground_msg.scale.x = 10.0;
  ground_msg.scale.y = 10.0;
  ground_msg.scale.z = 0.5;

  // Set the color -- be sure to set alpha to something non-zero!
  ground_msg.color.r = 0.5f;
  ground_msg.color.g = 0.5f;
  ground_msg.color.b = 0.5f;
  ground_msg.color.a = 1.0;

  ground_msg.lifetime = ros::Duration();

	ground_geom = dCreatePlane(space, 0., 0., 1., 0.);

	DiffDriveRobot bob = DiffDriveRobot(n, 1, world, space, 0., 0., 0.07); //0.071);

	while (ros::ok() && (simulation_time < MAX_TIME)) {
		ground_pub.publish(ground_msg);

		bob.draw();
//		bob.printLocation();

		for (i = 0; i < 1 / (float)(RVIZ_FPS * ODE_TIMESTEP); i++) {
			dSpaceCollide(space, 0, &nearCallback);
			bob.torqueLeftWheel(0.001);
			bob.torqueRightWheel(0.001);
			dWorldStep(world, ODE_TIMESTEP);
			dJointGroupEmpty (contact_group);
			simulation_time += ODE_TIMESTEP;
		}

		r.sleep();
	}

  dSpaceDestroy (space);
  dWorldDestroy (world);
  dCloseODE();
}

