#include "diff_drive_robot.h"

DiffDriveRobot::DiffDriveRobot(ros::NodeHandle n, int rviz_id, dWorldID world, dSpaceID space, dReal xcom, dReal ycom, dReal zcom) {
	dMatrix3 left_wheel_R;
	dMatrix3 right_wheel_R;	

// Initiate rigid bodies.
	body = dBodyCreate(world);
	left_wheel = dBodyCreate(world);
	right_wheel = dBodyCreate(world);
	rear_wheel = dBodyCreate(world);

	// Allocate space for mass objects.
	body_mass = (dMass *)malloc(sizeof(dMass));
	front_wheel_mass = (dMass *)malloc(sizeof(dMass));
	rear_wheel_mass = (dMass *)malloc(sizeof(dMass));

	// Assign values to mass objects.
	dMassSetBoxTotal(body_mass, body_mass_value, body_length, body_width, body_height);
	dMassSetCylinderTotal(front_wheel_mass, front_wheel_mass_value, 2, front_wheel_radius, front_wheel_width);
	dMassSetSphereTotal(rear_wheel_mass, rear_wheel_mass_value, rear_wheel_radius);

	// Assign mass objects to bodies.
	dBodySetMass(body, body_mass);
	dBodySetMass(left_wheel, front_wheel_mass);
	dBodySetMass(right_wheel, front_wheel_mass);
	dBodySetMass(rear_wheel, rear_wheel_mass);

	// Set body positons.
	dBodySetPosition(body, xcom, ycom, zcom);
	dBodySetPosition(left_wheel, xcom + front_wheel_xoffset, ycom + front_wheel_yoffset, zcom + front_wheel_zoffset);
	dBodySetPosition(right_wheel, xcom + front_wheel_xoffset, ycom - front_wheel_yoffset, zcom + front_wheel_zoffset);
	dBodySetPosition(rear_wheel, xcom + rear_wheel_xoffset, ycom, zcom + rear_wheel_zoffset);

	// Set front wheel rotations.
	dRFromAxisAndAngle(left_wheel_R, 1.0, 0.0, 0.0, -PI/2.);
	dRFromAxisAndAngle(right_wheel_R, 1.0, 0.0, 0.0, -PI/2.);
	dBodySetRotation(left_wheel, left_wheel_R);
	dBodySetRotation(right_wheel, right_wheel_R);

	// Create joints.
	left_axle = dJointCreateHinge(world, joint_group);
	right_axle = dJointCreateHinge(world, joint_group);
	rear_axle = dJointCreateBall(world, joint_group);

	// Attach joints to bodies.
	dJointAttach(left_axle, body, left_wheel);
	dJointAttach(right_axle, body, right_wheel);
	dJointAttach(rear_axle, body, rear_wheel);

	// Set joint positions.
	dJointSetHingeAnchor(left_axle, xcom + front_wheel_xoffset, ycom - front_wheel_yoffset, zcom + front_wheel_zoffset);
	dJointSetHingeAnchor(right_axle, xcom + front_wheel_xoffset, ycom + front_wheel_yoffset, zcom + front_wheel_zoffset);
	dJointSetBallAnchor(rear_axle, xcom + rear_wheel_xoffset, ycom, zcom + rear_wheel_zoffset);

	// Set axle orientations.
	dJointSetHingeAxis(left_axle, 0., 1., 0.);
	dJointSetHingeAxis(right_axle, 0., 1., 0.);

	// Create geometries.
	body_geom = dCreateBox(space, body_length, body_width, body_height);
	left_wheel_geom = dCreateCylinder(space, front_wheel_radius, front_wheel_width);
	right_wheel_geom = dCreateCylinder(space, front_wheel_radius, front_wheel_width);
	rear_wheel_geom = dCreateSphere(space, rear_wheel_radius);

	// Attach geometries to bodies.
	dGeomSetBody(body_geom, body);
	dGeomSetBody(left_wheel_geom, left_wheel);
	dGeomSetBody(right_wheel_geom, right_wheel);
	dGeomSetBody(rear_wheel_geom, rear_wheel);

	// Initialize message publisher.
	publisher = n.advertise<visualization_msgs::Marker>("robot", 4);

	// Initialize marker messages.
	body_msg.type = visualization_msgs::Marker::CUBE;
	left_wheel_msg.type = visualization_msgs::Marker::CYLINDER;
	right_wheel_msg.type = visualization_msgs::Marker::CYLINDER;
	rear_wheel_msg.type = visualization_msgs::Marker::SPHERE;

	// Set marker frame IDs and timestamps.
	body_msg.header.frame_id = "/my_frame";
  body_msg.header.stamp = ros::Time::now();
	left_wheel_msg.header.frame_id = "/my_frame";
  left_wheel_msg.header.stamp = ros::Time::now();
	right_wheel_msg.header.frame_id = "/my_frame";
  right_wheel_msg.header.stamp = ros::Time::now();
	rear_wheel_msg.header.frame_id = "/my_frame";
  rear_wheel_msg.header.stamp = ros::Time::now();

	// Set marker namespaces and IDs.
  body_msg.ns = "body";
  body_msg.id = rviz_id;
  left_wheel_msg.ns = "left_wheel";
  left_wheel_msg.id = rviz_id + 1;
  right_wheel_msg.ns = "right_wheel";
  right_wheel_msg.id = rviz_id + 2;
  rear_wheel_msg.ns = "rear_wheel";
  rear_wheel_msg.id = rviz_id + 3;

	// Set the marker actions.
  body_msg.action = visualization_msgs::Marker::ADD;
  left_wheel_msg.action = visualization_msgs::Marker::ADD;
  right_wheel_msg.action = visualization_msgs::Marker::ADD;
  rear_wheel_msg.action = visualization_msgs::Marker::ADD;

	draw();

	// Set the size of the markers.
	body_msg.scale.x = body_length;
	body_msg.scale.y = body_width;
	body_msg.scale.z = body_height;
	left_wheel_msg.scale.x = 2. * front_wheel_radius;
	left_wheel_msg.scale.y = 2. * front_wheel_radius;
	left_wheel_msg.scale.z = front_wheel_width;
	right_wheel_msg.scale.x = 2. * front_wheel_radius;
	right_wheel_msg.scale.y = 2. * front_wheel_radius;
	right_wheel_msg.scale.z = front_wheel_width;
	rear_wheel_msg.scale.x = 2. * rear_wheel_radius;
	rear_wheel_msg.scale.y = 2. * rear_wheel_radius;
	rear_wheel_msg.scale.z = 2. * rear_wheel_radius;

	// Set the colors of the markers.
	body_msg.color.r = 0.;
	body_msg.color.g = 0.;
	body_msg.color.b = 1.0;
	body_msg.color.a = 1.0;
	left_wheel_msg.color.r = 0.8;
	left_wheel_msg.color.g = 0.8;
	left_wheel_msg.color.b = 0.8;
	left_wheel_msg.color.a = 1.0;
	right_wheel_msg.color.r = 0.8;
	right_wheel_msg.color.g = 0.8;
	right_wheel_msg.color.b = 0.8;
	right_wheel_msg.color.a = 1.0;
	rear_wheel_msg.color.r = 0.8;
	rear_wheel_msg.color.g = 0.8;
	rear_wheel_msg.color.b = 0.8;
	rear_wheel_msg.color.a = 1.0;

	// Set the lifetime of the markers.
	body_msg.lifetime = ros::Duration();
	left_wheel_msg.lifetime = ros::Duration();
	right_wheel_msg.lifetime = ros::Duration();
	rear_wheel_msg.lifetime = ros::Duration();
}

void DiffDriveRobot::draw() {
	const dReal* body_pos = dBodyGetPosition(body);
	const dReal* left_wheel_pos = dBodyGetPosition(left_wheel);
	const dReal* right_wheel_pos = dBodyGetPosition(right_wheel);
	const dReal* rear_wheel_pos = dBodyGetPosition(rear_wheel);

	dQuaternion body_q = {0., 0., 0., 0.};
	dQuaternion left_wheel_q = {0., 0., 0., 0.}; 
	dQuaternion right_wheel_q = {0., 0., 0., 0.}; 
	dQuaternion rear_wheel_q = {0., 0., 0., 0.}; 
	
	dRtoQ(dBodyGetRotation(body), body_q);	
	dRtoQ(dBodyGetRotation(left_wheel), left_wheel_q);
	dRtoQ(dBodyGetRotation(right_wheel), right_wheel_q);
	dRtoQ(dBodyGetRotation(rear_wheel), rear_wheel_q);

	// Set the marker positions and orientations.
	body_msg.pose.position.x = body_pos[0];
	body_msg.pose.position.y = body_pos[1];
	body_msg.pose.position.z = body_pos[2];
	body_msg.pose.orientation.x = body_q[1];
	body_msg.pose.orientation.y = body_q[2];
	body_msg.pose.orientation.z = body_q[3];
	body_msg.pose.orientation.w = body_q[0];
	left_wheel_msg.pose.position.x = left_wheel_pos[0];
	left_wheel_msg.pose.position.y = left_wheel_pos[1];
	left_wheel_msg.pose.position.z = left_wheel_pos[2];
	left_wheel_msg.pose.orientation.x = left_wheel_q[1];
	left_wheel_msg.pose.orientation.y = left_wheel_q[2]; 
	left_wheel_msg.pose.orientation.z = left_wheel_q[3];
	left_wheel_msg.pose.orientation.w = left_wheel_q[0];
	right_wheel_msg.pose.position.x = right_wheel_pos[0];
	right_wheel_msg.pose.position.y = right_wheel_pos[1];
	right_wheel_msg.pose.position.z = right_wheel_pos[2];
	right_wheel_msg.pose.orientation.x = right_wheel_q[1];
	right_wheel_msg.pose.orientation.y = right_wheel_q[2];
	right_wheel_msg.pose.orientation.z = right_wheel_q[3]; 
	right_wheel_msg.pose.orientation.w = right_wheel_q[0];
	rear_wheel_msg.pose.position.x = rear_wheel_pos[0];
	rear_wheel_msg.pose.position.y = rear_wheel_pos[1];
	rear_wheel_msg.pose.position.z = rear_wheel_pos[2];
	rear_wheel_msg.pose.orientation.x = rear_wheel_q[1]; 
	rear_wheel_msg.pose.orientation.y = rear_wheel_q[2]; 
	rear_wheel_msg.pose.orientation.z = rear_wheel_q[3]; 
	rear_wheel_msg.pose.orientation.w = rear_wheel_q[0];

	// Publish the markers.
	publisher.publish(body_msg);
	publisher.publish(left_wheel_msg);
	publisher.publish(right_wheel_msg);
	publisher.publish(rear_wheel_msg);
}

void DiffDriveRobot::printLocation() {
	const dReal* position = dBodyGetPosition(body);
	const dReal* rotation = dBodyGetRotation(body);
	printf("(%.2f, %.2f, %.2f)\t(%.2f, %.2f, %.2f)\n", position[0], position[1], position[2], rotation[0], rotation[1], rotation[2]);
}

void DiffDriveRobot::torqueBody(float tau) {
	dBodyAddRelTorque(body, 0., 0., tau);
}

void DiffDriveRobot::torqueLeftWheel(float tau) {
	dBodyAddRelTorque(left_wheel, 0., 0., tau);
}

void DiffDriveRobot::torqueRightWheel(float tau) {
	dBodyAddRelTorque(right_wheel, 0., 0., tau);
}
