#!/bin/bash -i

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
#  Install required external auxiliary packages.
##

source redirect_output.sh

echo -e "\e[1m\e[103m\e[31m [RAPP] Installing auxiliary packages \e[0m"
# Allow remote secure connections to the RAPP-Platform.
redirect_all sudo apt-get install -y openssh-server
# Remove this?
redirect_all sudo apt-get install -y git
# Rapp-Text-To-Speech module depends on this.
redirect_all sudo apt-get install -y espeak
# Rapp-Text-To-Speech module depends on this.
redirect_all sudo apt-get install -y mbrola*
# Python package manager.
redirect_all sudo apt-get install -y python-pip
# Node.js and Node.js package manager
redirect_all sudo apt-get install -y npm nodejs
sudo ln -s /usr/bin/nodejs /usr/bin/node

# Install python weather related packages
redirect_all sudo pip install yweather
redirect_all sudo pip install forecastiopy
redirect_all sudo pip install geocoder

# Install python news reporter related packages
redirect_all sudo pip install eventregistry

# Grunt-Cli
redirect_all sudo npm install -g grunt-cli
redirect_all sudo rm -rf ${HOME}/tmp

# Enable Grunt shell auto-completion
append='eval "$(grunt --completion=bash)"'
grep -q "${append}" ~/.bashrc || echo -e          \
  "\n# Enable Grunt shell tab auto-completion\n${append}" \
  >> ~/.bashrc

# Load user's bash environment and flush output
redirect_all source ~/.bashrc
