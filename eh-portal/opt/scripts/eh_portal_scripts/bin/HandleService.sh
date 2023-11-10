#!/bin/bash
#this script will handle the services on LIN servers



host_name=$1
cid=$2
action=$3
service=$4


if [ ${host_name} ] && [ ! -z "${cid}" ] && [ ! -z "${action}" ] && [ ! -z "${service}" ] ; then


	ssh root@${host_name} "vzctl exec $cid '/opt/scripts/maintenance_scripts/bin/menu.sh $action $service'"



else

	echo "this script need arguments as below"
	echo "syntax is ./script name <server name> <container ID> <action> <service>"
	echo "example ./scriptname lin3vz 902 start apache"

fi
