# NOTES:
#       To make use of this script create "git_repos" directory in /home/ and put the buffalocar git clone in there
#       Create your own branch (don't use "master")

read -p 'Input branch to push to: ' BRANCH

# Remove existing files and folders from this git_repos 
# NOTE:  The .git folder is NOT deleted.
# (If we don't delete existing files/folders, which were cloned from the repo,
# this script wouldn't be useful for removing files that are no longer wanted.)
rm -rf ${HOME}/git_repos/buffalocar/*
 
# Create new destination directories
mkdir -p ${HOME}/git_repos/buffalocar/catkin_ws_laptop/buffalocar/
mkdir -p ${HOME}/git_repos/buffalocar/catkin_ws_pi/buffalocar_pi/

# Copy files from personal catkin_ws and personal Projects to the repo
cp -r ${HOME}/catkin_ws/src/buffalocar/ ${HOME}/git_repos/buffalocar/catkin_ws_laptop/
rsync -av --progress --exclude=notes_git_ignore --exclude=.git ${HOME}/Projects/buffalocar/ ${HOME}/git_repos/buffalocar/

# CD to the approriate git_repos directory/repo:
cd ${HOME}/git_repos/buffalocar

# Remove all of the *.pyc files.  We don't want them cluttering up our repo.
cd ${HOME}/git_repos/buffalocar
find . -type f -iname \*.pyc -delete

# Github requires some info from us.
# This probably only needs to happen once.
#read -p 'Enter your github email address: ' MYEMAIL
#read -p 'Enter your first and last name: ' MYNAME
#git config --global user.email "${MYEMAIL}"
#git config --global user.name "${MYNAME}"


# Make sure you are in the right branch
cd ${HOME}/git_repos/buffalocar
git checkout ${BRANCH}

# Stage all changes to be ready for a commit
git add .

# Commit changes to be moved from local to online version of your branch --- Will be asked for commit message - small summary of changes
git commit 

# Push the changes to the online repo
# git push
git push --set-upstream origin ${BRANCH}

