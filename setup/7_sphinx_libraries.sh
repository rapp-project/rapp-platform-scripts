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

source redirect_output.sh

RappPlatformPath="${HOME}/rapp_platform"
NoiseProfilesPath="$HOME/rapp_platform_files/audio_processing/rapp/noise_profile"
cmusphinxUrl="https://github.com/skerit/cmusphinx"
# sphinxbaseUrl="https://github.com/cmusphinx/sphinxbase.git"
sphinxbaseUrl="https://github.com/rapp-project/sphinxbase.git"

#download and compile sphinx4 extra libraries
echo -e "\e[1m\e[103m\e[31m [RAPP] Installing Sphinx4 Libraries \e[0m"
redirect_all sudo apt-get install -y swig
redirect_all sudo apt-get install -y autoconf
redirect_all sudo apt-get install -y python-scipy
redirect_all sudo apt-get install -y bison
redirect_all sudo apt-get install -y sox
redirect_all sudo apt-get install -y flac

echo -e "\e[1m\e[103m\e[31m [RAPP] Installing Sphinx4 CMU_SPHINX\e[0m"
cd ${RappPlatformPath}
redirect_all git clone ${cmusphinxUrl}
cd cmusphinx/cmuclmtk
redirect_all ./autogen.sh
redirect_all make
redirect_all sudo make install

echo -e "\e[1m\e[103m\e[31m [RAPP] Installing Sphinx4 Base \e[0m"
cd ${RappPlatformPath}
redirect_all git clone -b rapp_stable ${sphinxbaseUrl}
cd sphinxbase
redirect_all ./autogen.sh
redirect_all make
redirect_all sudo make install

echo -e "\e[1m\e[103m\e[31m [RAPP] Building Sphinx4.java wrapper \e[0m"
cd ${RappPlatformPath}/rapp-platform-catkin-ws/src/rapp-platform/rapp_speech_detection_sphinx4/src
redirect_all bash buildJava.sh

echo -e "\e[1m\e[103m\e[31m [RAPP] Copying rapp user's noise profiles \e[0m"
redirect_all mkdir -p ${NoiseProfilesPath}
redirect_all cp -R ${RappPlatformPath}/rapp-platform-scripts/setup/noise_profiles/* ${NoiseProfilesPath}
