#!/bin/bash

MAIN_REPO_DIR="${HOME}/git_repos"
CLONE_DIR="${HOME}/git_repos/buffalocar"

# Check if ~/git_repos exists.  If not, create it.
if [ -d "${MAIN_REPO_DIR}" ]; then
	echo "${MAIN_REPO_DIR} directory already exists."
else
	echo "${MAIN_REPO_DIR} directory not found. Creating it now."
	mkdir ${MAIN_REPO_DIR}
fi


if [ -d "${CLONE_DIR}" ]; then
	echo "${CLONE_DIR} clone already exists. Removing and cloning current master"
	cd ${MAIN_REPO_DIR}
	rm -rf ${CLONE_DIR}
	git clone -b master https://github.com/optimatorlab/buffalocar.git
else
	echo "${CLONE_DIR} clone not found.  Creating and cloning it now."
	cd ${MAIN_REPO_DIR}
	git clone -b master https://github.com/optimatorlab/buffalocar.git
fi

# Go into buffalocar clone and fetch all branches
echo "Fetching all buffalocar branches.  You will be prompted for username/password again."
cd ${CLONE_DIR}
git fetch --all


read -p 'Do you already have a branch on buffalocar? (y/n) ' uservar

if [ "${uservar}" = 'y' ]; then
	read -p 'Input branch name: ' BRANCH
	git checkout ${BRANCH}
	echo 'You are now attached to your branch!'

else
	read -p 'Enter Desired branch name: ' BRANCH
	git branch ${BRANCH}
	git checkout ${BRANCH}
	git push --set-upstream origin ${BRANCH}
	echo 'Branch created; You are attached!'
fi
