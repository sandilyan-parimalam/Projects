#!/bin/bash
#this script will help to generate the lin deployment form


host_name=$1
action=$2

if [ "${action}" == "listtomcatservices" ] ; then

	 if [ ! -z "${3}" ] ; then

		cid=${3}
		ssh root@${host_name} "/opt/scripts/lin_management_console/bin/GenerateLinDepForm.sh listtomcatservices $cid"
	else

		echo "syntax error"
	        echo "usage: ./script <linvz/lin3vz> <listtomcatservices> <container id>"

	
	fi


elif [ "${action}" == "listclient" ] ; then

	if [ ! -z "${host_name}" ] ; then

                ssh root@${host_name} "/opt/scripts/lin_management_console/bin/GenerateLinDepForm.sh listclient"


	else

	        echo "syntax error"
	        echo "usage: ./script <linvz/lin3vz> <listclient/listtomcatservices> <container id>"
	fi


else

	echo "syntax error"
	echo "usage: ./script <linvz/lin3vz> <listclient/listtomcatservices> <container id>"

fi
