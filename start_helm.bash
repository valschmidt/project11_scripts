#!/bin/bash
#
# Val Schmidt
# Center for Coastal and Ocean Mpapping
# Copyright 2018

echo ""
echo "WARNING: "
echo "  You are about to activate ASV piloting interface"
echo "  and place the IvP Helm in survey mode!"
echo ""
echo "  ANY POINTS PREVIOUSLY SENT TO THE WAYPOINT BEHAVIOR,"
echo "  (OR THE STARTUP DEFAULT SET [points = 0.0,0.0 : 20.0,50.0])"
echo "  WILL BE IMMEDIATELY EXECUTED! "
echo ""
echo "  For safety the vessel speed will be set to 0 m/s."
echo "  You can specify a new vessel speed (m/s) with:"
echo ""
echo "     rostopic pub --once /moos/wpt_updates std_msgs/String speed=2.75"
echo ""
echo "Do you want to continue? [y/n] n:default"
echo "> "

read ans

if [ "$ans" == "y" ]; then

	echo ""
	echo "Setting IvP Helm Speed to 0 m/s"
	rostopic pub --once /moos/wpt_updates std_msgs/String 'speed = 0'

	# Set the ASV Pilot Mode Active
	echo "Setting ASV Pilot Mode Active"
	rostopic pub --once /active std_msgs/Bool 1

	# Turn on the IvP Helm waypoint behavior.
	echo "Setting IvP Helm to 'survey' mode."
	rostopic pub --once /helm_mode std_msgs/String "survey"

	echo "" 
	echo "Helm is now active. Send speed (m/s) and waypoint updates (in the map reference frame) to /moos/wpt_updates"
	echo "     rostopic pub --once /moos/wpt_updates std_msgs/String points=100.0,0.0:200.0,100.0#speed=2.75"

fi
