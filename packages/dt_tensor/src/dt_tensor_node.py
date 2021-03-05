#!/usr/bin/env python3
import numpy as np
import os
import math
import cv2
from renderClass import Renderer

import rospy
import yaml
import sys
from duckietown.dtros import DTROS, NodeType
from sensor_msgs.msg import CompressedImage
from cv_bridge import CvBridge, CvBridgeError

import rospkg 


"""

This is a template that can be used as a starting point for the CRA1 exercise.
You need to project the model file in the 'models' directory on an AprilTag.
To help you with that, we have provided you with the Renderer class that render the obj file.

"""

class RTNode(DTROS):

    def __init__(self, node_name):

        # Initialize the DTROS parent class
        super(RTNode, self).__init__(node_name=node_name,node_type=NodeType.GENERIC)
        self.veh = rospy.get_namespace().strip("/")

        rospack = rospkg.RosPack()
        # Initialize an instance of Renderer giving the model in input.
        self.renderer = Renderer(rospack.get_path('dt_tensor') + '/src/models/duckie.obj')

        #
        #   Write your code here
        #

        rospack = rospkg.RosPack()

        # Render the obj
        #self.rend = Renderer(rospack.get_path('dt_tensor')+'/src/models/')


        # Subscribe to topic
        camera_topic="/"+self.veh+"/camera_node/image/compressed"

        #Setup the camera subscriber
        self.camera = rospy.Subscriber(camera_topic, CompressedImage, self.imageCallback)

        # publisher on the topic robot name/node_name/map file basename
        self.pub = rospy.Publisher("~/"+self.veh+"/"+node_name+"/image/compressed", CompressedImage, queue_size=1)
        

        self.log("Initialized")



    
    def imageCallback(self,data):
        """called when the image/compressed publish something"""
        # convert compressed image to opencv images
        img = self.readImage(data)

        img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

        tags = self.at_detector.detect(img_gray, True, self.camera_params, 0.065)
        for tag in tags:
            projection = self.projection_matrix(self.intrinsic, np.array(tag.homography).reshape(3,3))

            img = self.rend.render(img, projection)

        # publish image
        cmprsmsg = self.bridge.cv2_to_compressed_imgmsg(img)
        self.pub.publish(cmprsmsg)



    def readImage(self, msg_image):
        """
            Convert images to OpenCV images
            Args:
                msg_image (:obj:`CompressedImage`) the image from the camera node
            Returns:
                OpenCV image
        """
        try:
            cv_image = self.bridge.compressed_imgmsg_to_cv2(msg_image)
            return cv_image
        except CvBridgeError as e:
            self.log(e)
            return []

    def readYamlFile(self,fname):
        """
            Reads the 'fname' yaml file and returns a dictionary with its input.

            You will find the calibration files you need in:
            `/data/config/calibrations/`
        """
        with open(fname, 'r') as in_file:
            try:
                yaml_dict = yaml.load(in_file)
                return yaml_dict
            except yaml.YAMLError as exc:
                self.log("YAML syntax error. File: %s fname. Exc: %s"
                         %(fname, exc), type='fatal')
                rospy.signal_shutdown()
                return


    def onShutdown(self):
        super(RTNode, self).onShutdown()


if __name__ == '__main__':
    # Initialize the node
    camera_node = RTNode(node_name='dt_tensor')
    # Keep it spinning to keep the node alive
    rospy.spin()