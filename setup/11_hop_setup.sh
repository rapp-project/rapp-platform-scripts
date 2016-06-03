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

# Authors: Konstantinos Panyiotou
# Contact: klpanagi@gmail.com
##

source redirect_output.sh

RappPlatformPath="${HOME}/rapp_platform"
BiglooTarballName="bigloo4.3a"
BiglooUrl="http://rapp-project.eu/${BiglooTarballName}.tar.gz"
HopRepoUrl="https://github.com/manuel-serrano/hop.git"
HopCommitIndex="58c2d43e43d1358b6d65506f8167a0cdfcd3ca51"

echo -e "\e[1m\e[103m\e[31m [RAPP] Installing HOP by repos \e[0m"

# Keep current directory
curr=$(pwd)
#sudo sh -c 'echo "deb ftp://ftp-sop.inria.fr/indes/rapp/UBUNTU lts hop" >> \
#  /etc/apt/sources.list'

redirect_all sudo apt-get install libunistring-dev

# Bigloo installation
cd ${RappPlatformPath}
mkdir hop-bigloo
cd hop-bigloo
redirect_all wget ${BiglooUrl}

echo -e "\e[1m\e[103m\e[31m [RAPP] Installing Bigloo \e[0m"
redirect_all tar -zxf "${BiglooTarballName}.tar.gz"
cd "${BiglooTarballName}"
redirect_all ./configure
redirect_all make
redirect_all make test
redirect_all make compile-bee
redirect_all sudo make install
redirect_all sudo make install-bee

# HOP installation
echo -e "\e[1m\e[103m\e[31m [RAPP] Installing HOP \e[0m"
cd ..
redirect_all git clone ${HopRepoUrl}
cd hop
redirect_all git checkout ${HopCommitIndex}
redirect_all ./configure
redirect_all make
redirect_all sudo make install
redirect_all make doc
redirect_all sudo make install

echo -e "\e[1m\e[103m\e[31m [RAPP] Finished HOP/Bigloo \e[0m"

