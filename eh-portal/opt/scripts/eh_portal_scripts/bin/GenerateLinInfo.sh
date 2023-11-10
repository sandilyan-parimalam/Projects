#!/bin/bash
#Sandy
#this script will invoke the scripts on lin servers


server_name=$1

if [ ! -z "${server_name}" ] ; then

	is_lin=`echo "${server_name}" | grep lin`

	if [ ! -z "${is_lin}" ] ; then
		ssh root@${server_name} '/opt/scripts/lin_management_console/bin/GenerateLinInfo.sh'
	else
                ssh root@${server_name} '/opt/scripts/LX_management_console/bin/GenerateLXInfo.sh'
	
	fi

else

	echo "Please provide the server name as an argument to this script"

fi
