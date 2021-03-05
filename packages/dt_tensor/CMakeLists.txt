cmake_minimum_required(VERSION 2.8.3)
project(dt_tensor)

find_package(catkin REQUIRED COMPONENTS
  rospy
  sensor_msgs
  cv_bridge
  duckietown_msgs
)

catkin_package()