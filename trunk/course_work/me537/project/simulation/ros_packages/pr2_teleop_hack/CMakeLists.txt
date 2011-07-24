cmake_minimum_required(VERSION 2.4.6)
include($ENV{ROS_ROOT}/core/rosbuild/rosbuild.cmake)
rosbuild_init()
rosbuild_add_executable(bin/pr2_teleop_hack src/teleop_pr2_keyboard.cpp)
