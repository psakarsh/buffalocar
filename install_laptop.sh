#!/bin/bash

set -e

# See https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
# for more info on text color in terminal.
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "This script overwrites the following directories (and their subdirectories):"
echo "     ~/catkin_ws/src/buffalocar/"
echo "     ~/Projects/buffalocar/"
echo -e "${YELLOW}A backup copy of these directories will be created on the Desktop.${NC}"
echo ""

echo -e "${RED}This script is for LAPTOP or DESKTOP installations only (not for the Raspberry Pi).${NC}"
echo -n "Do you wish to continue (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo "OK.  Starting Installation..."
    echo ""

	# Get a "unique" timestamp:
	timestamp=$(date "+%Y-%m-%dT%H%M%S")
	# echo ${timestamp}	# 2017-11-16T063639

	# Define the name of the .tar archive:
	MYFILE="${HOME}/Desktop/buffalocar_archive_${timestamp}.tar.bz2"
	# echo ${MYFILE}

	# Create the archive (but only if at least one directory exists):
	myBCdir=""
	myProjDir=""
	SomethingToDo="False"
	if [ -d "${HOME}/catkin_ws/src/buffalocar" ]; then	
		myBCdir="${HOME}/catkin_ws/src/buffalocar"
		SomethingToDo="True"
	fi
	if [ -d "${HOME}/Projects/buffalocar" ]; then
		myProjDir="${HOME}/Projects/buffalocar"
		SomethingToDo="True"
	fi
	
	if [ ${SomethingToDo} == "True" ]; then
		# Create the archive:
		tar -chjvf ${MYFILE} ${myBCdir} ${myProjDir}
		echo -e "${YELLOW}Your backup archive is saved as ${MYFILE}.${NC}"
		echo ""
	else
		echo "You don't have any content to backup."
		echo ""
	fi	

	# Store the present working directory:
	myPWD=$PWD

	# Delete any old buffalocar content from catkin
	rm -rf ${HOME}/catkin_ws/src/buffalocar

	# Rebuild catkin (thus completely removing the buffalocar package)
	cd ${HOME}/catkin_ws
	catkin_make
		
	# Create an empty buffalocar package
	cd ${HOME}/catkin_ws/src
	catkin_create_pkg buffalocar
	
	# Copy the catkin contents from the archive to the new package
	cp -a ${myPWD}/catkin_ws_laptop/buffalocar/. ${HOME}/catkin_ws/src/buffalocar
	
	# Change the permissions on scripts
	cd ${HOME}/catkin_ws/src/buffalocar/scripts
	chmod +x viewer.py
	chmod +x start_viewer.sh
	 
	# Rebuild catkin 
	cd ${HOME}/catkin_ws
	catkin_make
			

	# Delete any old "buffalocar" content from Projects
	# NOTE:  Leave the content in folders that don't appear in GitHub.
	rm -f ${HOME}/Projects/buffalocar/*.*
	rm -rf ${HOME}/Projects/buffalocar/docs
	rm -rf ${HOME}/Projects/buffalocar/catkin_ws_pi
		
	# Copy the contents of the main archive folder to Projects/buffalocar.
	# NOTE: Exclude the directories that don't belong in Projects.
	rsync -av --progress --exclude="catkin_ws_laptop" ${myPWD}/ ${HOME}/Projects/buffalocar


	echo ""
	echo "The installation script is done."
	echo ""
	if [ ${SomethingToDo} == "True" ]; then
		echo "Your backup archive is saved as ${MYFILE}."
	else
		echo "No backup archive was required/created."
	fi	
	echo ""	
	echo "See ~/catkin_ws/src/buffalocar."
	# echo "There is no launcher icon." 

	
else
    echo "Installation Cancelled."
fi

	
