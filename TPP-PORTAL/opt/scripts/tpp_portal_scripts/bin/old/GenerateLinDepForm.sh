#!/bin/bash
#this script will help to generate the lin deployment form


host_name=$1
action=$2

if [ "${action}" == "listtomcatservices" ] ; then

	if [ "${host_name}" == "linvz" ] && [ ! -z "${3}" ] ; then

		cid=${3}
		ssh root@asplinvz "/opt/scripts/lin_management_console/bin/GenerateLinDepForm.sh listtomcatservices $cid"

	elif [ "${host_name}" == "lin3vz" ] && [ ! -z "${3}" ] ; then

                cid=${3}
                ssh root@asplin3vz.mytestorghealth.com "/opt/scripts/lin_management_console/bin/GenerateLinDepForm.sh listtomcatservices $cid"
 

	else

		echo "syntax error"
	        echo "usage: ./script <linvz/lin3vz> <listtomcatservices> <container id>"

	
	fi


elif [ "${action}" == "listclient" ] ; then


	if [ "${host_name}" == "linvz" ] ; then

                ssh root@asplinvz "/opt/scripts/lin_management_console/bin/GenerateLinDepForm.sh listclient"
	

	elif [ "${host_name}" == "lin3vz" ] ; then


                ssh root@asplin3vz.mytestorghealth.com "/opt/scripts/lin_management_console/bin/GenerateLinDepForm.sh listclient"

	else

	        echo "syntax error"
	        echo "usage: ./script <linvz/lin3vz> <listclient/listtomcatservices> <container id>"
	fi


else

	echo "syntax error"
	echo "usage: ./script <linvz/lin3vz> <listclient/listtomcatservices> <container id>"

fi
