#!/bin/bash
#Sandy
#this script will collect all the instance info based on the conf

base_dir=/opt/scripts/tpp_portal_scripts
Now=`date +%F_%H-%M-%S`


function PreCheck() {

if [  -f "${base_dir}/bin/TPPPortal.conf" ] ; then

	source "${base_dir}/bin/TPPPortal.conf"

fi

}

function ListEnv(){

for env in ${envs}
do

echo " <li><a  href="/tpp-portal/php/EnvPortal.php?env=${env}" target="_blank"><font color=green>${env}</font></a></li>"

done

}



PreCheck
ListEnv
