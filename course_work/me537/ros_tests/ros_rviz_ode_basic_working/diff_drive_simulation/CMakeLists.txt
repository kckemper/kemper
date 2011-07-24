cmake_minimum_required(VERSION 2.4.6)
include($ENV{ROS_ROOT}/core/rosbuild/rosbuild.cmake)

#set(ROS_COMPILE_FLAGS "-W -Wall -Wno-unused-parameter -fno-strict-aliasing -I /usr/local/share/ode-0.11.1/include/ -l ode")
#set (CMAKE_EXE_LINKER_FLAGS  "-I /usr/local/share/ode-0.11.1/include/ -l ode" )

# Set the build type.  Options are:
#  Coverage       : w/ debug symbols, w/o optimization, w/ code-coverage
#  Debug          : w/ debug symbols, w/o optimization
#  Release        : w/o debug symbols, w/ optimization
#  RelWithDebInfo : w/ debug symbols, w/ optimization
#  MinSizeRel     : w/o debug symbols, w/ optimization, stripped binaries
#set(ROS_BUILD_TYPE RelWithDebInfo)

rosbuild_init()

#set the default path for built executables to the "bin" directory
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
#set the default path for built libraries to the "lib" directory
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)

find_package(GLUT)
if(GLUT_FOUND)
    include_directories(${GLUT_INCLUDE_DIR})
else(GLUT_FOUND)
    message(FATAL_ERROR "GLUT not found.")
endif(GLUT_FOUND)

#find_package(OPENDE)
#if(OPENDE_FOUND)
#    include_directories(${ODE_INCLUDE_DIR})
#else(OPENDE_FOUND)
#    message(FATAL_ERROR "ODE not found.")
#endif(OPENDE_FOUND)

#uncomment if you have defined messages
#rosbuild_genmsg()
#uncomment if you have defined services
#rosbuild_gensrv()

#common commands for building c++ executables and libraries
#rosbuild_add_library(${PROJECT_NAME} src/example.cpp)
#target_link_libraries(${PROJECT_NAME} another_library)
#rosbuild_add_boost_directories()
#rosbuild_link_boost(${PROJECT_NAME} thread)
#rosbuild_add_executable(example examples/example.cpp)
#target_link_libraries(example ${PROJECT_NAME})

#rosbuild_add_compile_flags(simulation "-I /usr/local/share/ode-0.11.1/include/ -l ode")
#rosbuild_add_link_flags(simulation "-I /usr/local/share/ode-0.11.1/include/ -l ode")

#include_directories(/usr/local/share/ode-0.11.1/include/)

rosbuild_add_executable(simulation src/simulation.cpp)
