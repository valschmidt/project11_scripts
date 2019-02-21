#!/bin/bash
#
# A script to start the project11 autnoomous system backseat driver.
#
# Val Schmidt
# Center for Coastal and Ocean Mapping
# School of Marine Science and Ocean Engineering
# University of New Hampshire
# 2019

LAUNCH_LOG_FILE=${HOME}/project11/log/project11_launch_log.txt

# Check to see if we are executing in simulation mode. 
if [ "$1" == '-sim' ]; then 
	SIM=1
elif [ "$1" == '' ]; then
	SIM=0
else 
	echo "USAGE:"
	echo "    ./start_project11.sh [-sim]"
	exit
fi

# Setup path names for ROS and NODE log files.
LOGDIR="${HOME}/project11/log"
LAUNCHDIRNAME=`date -u --iso-8601=seconds | sed 's/\:/-/g'`
LOGDIR_FULLPATH="${LOGDIR}/${LAUNCHDIRNAME}"

# Log some header information.
touch "${LAUNCH_LOG_FILE}"
echo "" >> ${LAUNCH_LOG_FILE}
echo "############################################################" >> ${LAUNCH_LOG_FILE}
if [ "${SIM}" == 1 ]; then
	echo "Running start_project11.sh Simulation Mode :: ${LAUNCHDIRNAME}" >> ${LAUNCH_LOG_FILE}
else
	echo "Running start_project11.sh :: ${LAUNCHDIRNAME}" >> ${LAUNCH_LOG_FILE}
fi
echo "############################################################" >> ${LAUNCH_LOG_FILE}
echo "" >> ${LAUNCH_LOG_FILE}

## Set up log directoires. 
echo "CREATING LOG DIRECTORIES: ${LOGDIR_FULLPATH}" >> ${LAUNCH_LOG_FILE}
mkdir -p "${LOGDIR_FULLPATH}/moos"
mkdir -p "${LOGDIR_FULLPATH}/ros/nodes"

cd "${LOGDIR}"
ln -s "${LOGDIR_FULLPATH}" latest

# Update links to new log location(s).
#cd "${LOGDIR_FULLPATH}"

# Remove old links.
#if [ -L "nodes" ]; then
#	rm nodes
#fi
#if [ -L "moos" ]; then
#	rm moos
#fi
# Create new links.
#ln -s "${LOGDIR_FULLPATH}/nodes"
#ln -s "${LOGDIR_FULLPATH}/moos"

# If this script has been run already, then ${HOME}/.ros will have been 
# moved to a previous log directory and ${HOME}/.ros will be a soft link
# to that place. In that case, we remove the soft link before creating
# a new one to the new log location. 
if [ -L "${HOME}/.ros" ]; then
	rm "${HOME}/.ros"
else
	# If this script has not been run in the past (a new install), then ${HOME}/.ros 
	# will be a directory and it should be moved to the new log directory.
	mv "${HOME}/.ros" "${LOGDIR_FULLPATH}/ros"
fi

ln -s "${LOGDIR_FULLPATH}/ros" "${HOME}/.ros"


set -e
{
source "/opt/ros/${ROS_DISTRO}/setup.bash"
source "${HOME}/project11/catkin_ws/devel/setup.bash"
export ROS_WORKSPACE="${HOME}/project11/catkin_ws"
} &>> ${LAUNCH_LOG_FILE}

# Launch ROS
if [ "${SIM}" == 1 ]; then
	echo "Executing in Simulation Mode." >> ${LAUNCH_LOG_FILE}
	{
	roslaunch project11 sim_local.launch
	} &>> ${LAUNCH_LOG_FILE}


else
	{
	echo "Executing in Live Mode." >> ${LAUNCH_LOG_FILE}
	roslaunch project11 mystique.launch
	} &>> ${LAUNCH_LOG_FILE}
fi