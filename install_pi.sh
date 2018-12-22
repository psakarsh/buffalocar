#!/bin/bash

set -e

# See https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
# for more info on text color in terminal.
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "This script overwrites the following directory (and its subdirectories):"
echo "     catkin_ws/src/buffalocar_pi/"
echo -e "${YELLOW}A backup copy of this directory will be created on the Desktop.${NC}"
echo ""

echo -e "${RED}This script is for RASPBERRY PI installations only.${NC}"
echo -n "Do you wish to continue (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo "OK.  Starting Installation..."
    echo ""

	# Get a "unique" timestamp:
	timestamp=$(date "+%Y-%m-%dT%H%M%S")
	# echo ${timestamp}	# 2017-11-16T063639

	# Define the name of the .tar archive:
	MYFILE="${HOME}/Desktop/buffalocar_pi_archive_${timestamp}.tar.bz2"
	# echo ${MYFILE}

	# Create the archive (but only if that directory already exists):
	if [ -d "${HOME}/catkin_ws/src/buffalocar_pi" ]; then
		tar -chjvf ${MYFILE} ${HOME}/catkin_ws/src/buffalocar_pi
		echo -e "${YELLOW}Your backup archive is saved as ${MYFILE}.${NC}"
		echo ""
	else
		echo "You don't have a buffalocar_pi package.  No backup is being created."
	fi	

	# Store the present working directory:
	myPWD=$PWD

	# Delete any old buffalocar_pi content from catkin
	rm -rf ${HOME}/catkin_ws/src/buffalocar_pi

	# Rebuild catkin (thus completely removing the buffalocar_pi package)
	cd ${HOME}/catkin_ws
	catkin_make
		
	# Create an empty buffalocar_pi package
	cd ${HOME}/catkin_ws/src
	catkin_create_pkg buffalocar_pi
	
	# Copy the catkin contents from the archive to the new package
	cp -a ${myPWD}/catkin_ws_pi/buffalocar_pi/. ${HOME}/catkin_ws/src/buffalocar_pi
	
	# Change the permissions on scripts
	cd ${HOME}/catkin_ws/src/buffalocar_pi/scripts
	chmod +x autodriver.py
	chmod +x start_pi.sh
	chmod +x stop_pi.sh
	 
	# Rebuild catkin 
	cd ${HOME}/catkin_ws
	catkin_make
			
	echo ""
	echo "The installation script is done.  See ~/catkin_ws/src/buffalocar_pi."
	echo ""
	echo "Your backup archive is saved as ${MYFILE} (if you already had a buffalocar_pi package install)."
	echo ""	
	
	# If appropriate, remind the user to change the hostname
	# echo -e "Your hostname is ${YELLOW}$(hostname)${NC}."
	# if [ $(hostname) == "ROS-EDU" ] ; then
	#	echo -e "${RED}YOU NEED TO CHANGE YOUR HOSTNAME.${NC}"
	#	echo -e "${RED}See the instructions on https://github.com/optimatorlab/turtlebotrace."
	#	echo ""
	# fi
else
    echo "Installation Cancelled."
fi

	
