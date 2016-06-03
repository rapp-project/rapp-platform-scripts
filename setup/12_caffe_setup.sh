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

# Authors: Athanassios Kintsakis
# Contact: akintsakis@issel.ee.auth.gr
##

##
#  Caffe installation.
#  For more information regarding Caffe itself visit:
#    http://caffe.berkeleyvision.org/
##

source redirect_output.sh

echo -e "\e[1m\e[103m\e[31m [RAPP] Installing Caffe \e[0m"
RappPlatformPath="${HOME}/rapp_platform"
RappPlatformFilesPath="${HOME}/rapp_platform_files"
KnowrobPath="${RappPlatformPath}/knowrob_catkin_ws"

#Copy mapping of caffe classes to ontology classes file in RappPlatformFiles
cp ./caffeOntologyClassesBridge $RappPlatformFilesPath"/"

# Install deb package dependencies
redirect_all sudo apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
redirect_all sudo apt-get install -y --no-install-recommends libboost-all-dev
redirect_all sudo apt-get install -y libgflags-dev libgoogle-glog-dev liblmdb-dev
redirect_all sudo apt-get install -y libatlas-base-dev
redirect_all sudo apt-get install -y the python-dev

# Clone Caffe repo
cd $RappPlatformPath
redirect_all git clone https://github.com/BVLC/caffe.git

# Install python dependencies\
echo -e "\e[1m\e[103m\e[31m [RAPP] Installing python dependencies \e[0m"
cd $RappPlatformPath"/caffe/python"
for req in $(cat requirements.txt); do echo -n "." && redirect_all sudo -H pip install $req; done

# Create the Makefile config
cd $RappPlatformPath"/caffe"
cp Makefile.config.example Makefile.config
# Edit the Makefile for cpu only compilation
sed -i '/# CPU_ONLY := 1/a CPU_ONLY := 1' Makefile.config

# Make all, make test and run tests
echo -e "\e[1m\e[103m\e[31m [RAPP] Making all\e[0m"
redirect_all make all
echo -e "\e[1m\e[103m\e[31m [RAPP] Making pycaffe\e[0m"
redirect_all make pycaffe
#echo "running make test but skipping running tests"
# redirect_all make test
# redirect_all make runtest

# Download bvlc_reference_caffenet pretained model
# Warning this download is very slow
#./scripts/download_model_binary.py ./models/bvlc_reference_caffenet
echo -e "\e[1m\e[103m\e[31m [RAPP] Cloning rapp-resources Repo\e[0m"
cd ~/rapp_platform_files
redirect_all git clone https://github.com/rapp-project/rapp-resources.git
cd ~/rapp_platform_files/rapp-resources
rm -rf ~/rapp_platform/caffe/models/
#copy models into caffe directory
cp -r ./caffe/caffe_models ~/rapp_platform/caffe/models
cd ~/rapp_platform/caffe/models/bvlc_reference_caffenet
#merge splitted model into one file
cat bvlc_reference_caffenet_piece_* > bvlc_reference_caffenet.caffemodel
rm bvlc_reference_caffenet_piece_*

#create example images folder and load sample image
mkdir ~/rapp_platform_files/image_processing
cp -r ~/rapp_platform_files/rapp-resources/caffe/example_images ~/rapp_platform_files/image_processing/
cp ~/rapp_platform_files/rapp-resources/caffe/synset_words.txt ~/rapp_platform/caffe/data/ilsvrc12/synset_words.txt

# Append to user's .bashrc file.
append="PYTHONPATH=$PYTHONPATH:~/rapp_platform/caffe/python"
grep -q "${append}" ~/.bashrc || echo -e          \
  "\n# Caffe Python modules\n${append}" \
  >> ~/.bashrc

echo -e "\e[1m\e[103m\e[31m [RAPP] Caffe installation Finished \e[0m"
