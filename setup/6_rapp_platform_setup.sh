#!/bin/bash -ie

##

#Copyright 2015 RAPP

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

    #http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

# Authors: Manos Tsardoulias
# Contact: etsardou@iti.gr
##

##
#  Build Rapp Platform onto the system.
##


RappPlatformWs="${HOME}/rapp_platform/rapp-platform-catkin-ws"
RappWebServicesPkgPath="${RappPlatformWs}/src/rapp-platform/rapp_web_services"

# Install libzbar used by the qr_detection module.
sudo apt-get install -qq -y libzbar-dev &> /dev/null
sudo ldconfig &> /dev/null

echo -e "\e[1m\e[103m\e[31m [RAPP] Create Github folders \e[0m"
# Create folder for RAPP platform repo
if [ -d "${RappPlatformWs}" ]; then
  rm -rf ${RappPlatformWs}
fi

mkdir -p ${RappPlatformWs} && cd ${RappPlatformWs}
mkdir src && cd src

# Initialize Rapp Platform catkin workspace
echo -e "\e[1m\e[103m\e[31m [RAPP] Initializing Rapp Catkin Workspace\e[0m"
catkin_init_workspace &> /dev/null

# Clone the repository (public key should have been setup)
RAPP_PLATFORM_BRANCH='master'
if [ -n "${TRAVIS_BRANCH}" ]; then
  RAPP_PLATFORM_BRANCH="${TRAVIS_BRANCH}"
fi
echo -e "\e[1m\e[103m\e[31m [RAPP] Cloning the rapp-platform repo, branch: $RAPP_PLATFORM_BRANCH\e[0m"
git clone --recursive --branch=$RAPP_PLATFORM_BRANCH https://github.com/rapp-project/rapp-platform.git &> /dev/null

RAPP_API_BRANCH='master'
if [ "${TRAVIS_BRANCH}" != "master" ]; then
  RAPP_API_BRANCH="devel"
fi
echo -e "\e[1m\e[103m\e[31m [RAPP] Cloning the rapp-api repo, branch: $RAPP_API_BRANCH\e[0m"
git clone --branch=$RAPP_API_BRANCH https://github.com/rapp-project/rapp-api.git &> /dev/null

echo -e "\e[1m\e[103m\e[31m [RAPP] Installing pip dependencies\e[0m"
cd rapp-api/python
# Install the Python Rapp API in development mode under user's space
python setup.py install --user 1> /dev/null

# Append to user's .bashrc file.
append="source ~/rapp_platform/rapp-platform-catkin-ws/devel/setup.bash --extend"
grep -q "${append}" ~/.bashrc || echo -e          \
  "\n# Rapp Platform catkin workspace\n${append}" \
  >> ~/.bashrc

# catkin_make rapp-platform
echo -e "\e[1m\e[103m\e[31m [RAPP] Building Rapp Platform\e[0m"
cd ${RappPlatformWs} && catkin_make


echo -e "\e[1m\e[103m\e[31m [RAPP] Cloning scripts repository\e[0m"
cd ${HOME}/rapp_platform
RAPP_SCRIPTS_BRANCH='master'
if [ "${TRAVIS_BRANCH}" != "master" ]; then
  RAPP_SCRIPTS_BRANCH="devel"
fi
git clone --branch=$RAPP_SCRIPTS_BRANCH https://github.com/rapp-project/rapp-platform-scripts.git &> /dev/null

# Install rapp_web_services package deps
cd ${RappWebServicesPkgPath}
echo -e "\e[1m\e[103m\e[31m [RAPP] Installing web_services package dependencies\e[0m"
npm install
