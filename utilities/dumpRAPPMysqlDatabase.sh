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
i=0;
for j in `cat /etc/db_credentials`
do
   array[$i]=$j;
   #do manipulations here
    i=$(($i+1));

done
echo "Value of third element in my array : ${array[1]} ";
username=${array[0]};
password=${array[1]};

mysqldump -u $username -p$password rapp_platform > $HOME/mysqlBckup_$DATE
