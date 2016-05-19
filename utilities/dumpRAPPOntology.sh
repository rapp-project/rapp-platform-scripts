#!/bin/bash

##
# Copyright 2015 RAPP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DATE=`date +%Y-%m-%d:%H:%M:%S`
rosservice call /rapp/rapp_knowrob_wrapper/dump_ontology "header:
  seq: 0
  stamp:
    secs: 0
    nsecs: 0
  frame_id: ''
file_url: '"$HOME"/ontology_"$DATE"'"
