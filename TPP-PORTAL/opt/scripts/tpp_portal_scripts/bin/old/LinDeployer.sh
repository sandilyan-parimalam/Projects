#!/bin/bash
#this script will handle the deployments on LIN servers

hst_name="${1}"
container_id="${2}"
instance_name="${3}"
ftp_path="${4}"
war_name="${5}"




if [ "${hst_name}" == "linvz" ] && [ ! -z "${container_id}" ]  && [ ! -z "${instance_name}" ] &&  [ ! -z "${ftp_path}" ] &&  [ ! -z "${war_name}" ] ; then


	ssh root@asplinvz "vzctl exec $container_id '/opt/scripts/maintenance_scripts/bin/menu.sh linupdate $instance_name $ftp_path $war_name'"



elif [ "${hst_name}" == "lin3vz" ] && [ ! -z "${container_id}" ]  && [ ! -z "${instance_name}" ] &&  [ ! -z "${ftp_path}" ] &&  [ ! -z "${war_name}" ] ; then


        ssh root@asplin3vz.mytestorghealth.com "vzctl exec $container_id '/opt/scripts/maintenance_scripts/bin/menu.sh linupdate $instance_name $ftp_path $war_name'"


else

	echo "syntax error"
	echo "usage: ./script <linvz/lin3vz> <container_id> <instance_name> <ftp_path> <war_name>"

fi
