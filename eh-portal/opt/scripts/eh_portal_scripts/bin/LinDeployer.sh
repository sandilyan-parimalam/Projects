#!/bin/bash
#this script will handle the deployments on LIN servers

hst_name="${1}"
container_id="${2}"
instance_name="${3}"
ftp_path="${4}"
war_name="${5}"




if [ ! -z "${hst_name}" ] && [ ! -z "${container_id}" ]  && [ ! -z "${instance_name}" ] &&  [ ! -z "${ftp_path}" ] &&  [ ! -z "${war_name}" ] ; then


	ssh root@${hst_name} "vzctl exec $container_id '/opt/scripts/maintenance_scripts/bin/menu.sh linupdate $instance_name $ftp_path $war_name'"

else

	echo "syntax error"
	echo "usage: ./script <linvz/lin3vz> <container_id> <instance_name> <ftp_path> <war_name>"

fi
