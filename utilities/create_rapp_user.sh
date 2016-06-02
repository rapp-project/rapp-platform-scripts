#!/bin/bash -e

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

# Authors: Konstantinos Panayiotou, Manos Tsardoulias, Aris Thallas
# Contact: klpanagi@gmail.com, etsardou@iti.gr, aris.thallas@{gmail.com, iti.gr}
##


##
#  Use this script to create and login a new RAPP User.
##

info="Minimal required fields for user creation:\n"
info+="* 1) username\n"
info+="* 2) password\n"
info+="* 3) user language\n\n"

echo -e "$info"

read -p "Username: "  username
read -p "Language: " language
read -sp "Password: "  passwd

echo ""

echo "Creating new user"
rosservice call /rapp/rapp_application_authentication/add_new_user_from_platfrom "{creator_username: 'rapp', creator_password: 'rapp', new_user_username: '$username', new_user_password: '$passwd', language: '$language'}"
echo ""

echo "Login in"
rosservice call /rapp/rapp_application_authentication/login "{username: '$username', password: '$passwd', device_token: 'rapp_device'}"
