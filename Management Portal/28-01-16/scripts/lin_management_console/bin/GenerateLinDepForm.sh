#!/bin/bash
#this script will help the lin deployment for
#manul execution invalid
> /opt/scripts/lin_management_console/work/tmp_file.txt

input=$1

if [ "$input" == "listclient" ] ; then

	for i in `vzlist | grep running | awk '{print $1}'`
	do
		client_name=`vzlist | grep ${i} | grep -v grep | head -1 | awk '{print $5}' | cut -d "." -f1|sed 's#www##g'`
		echo "<option value=${i} > ${client_name} </option>"
	done

elif [ "$input" == "listtomcatservices" ] ; then

	containerid=$2
	if [ ! -z "${containerid}" ] ; then
		status=`vzctl status $containerid | grep "running"`
		if [ ! -z "${status}" ] ; then
			tomcat_instances=`vzctl exec ${containerid} "ls /usr/local/ | grep ^tomcat | egrep -v 'grep|bk|bac|old|not|dont|use|z'"`
			if [ ! -z "{tomcat_instances}" ] ; then
				for i in `vzctl exec ${containerid} "ls /usr/local/ | grep ^tomcat | egrep -v 'grep|bk|bac|old|not|dont|use|z'"`
				do
					echo "<option value=${i}> ${i} </option>"
					echo "<option value=${i}> ${i} </option>" >> /opt/scripts/lin_management_console/work/tmp_file.txt
		
				done
			else
				echo "there is no tomcat instance is running on this machine"
                                echo "there is no tomcat instance is running on this machine" > /opt/scripts/lin_management_console/work/tmp_file.txt

				exit;

			fi
		else

			echo "given container id may be not running or invalid"
                        echo "given container id may be not running or invalid" > /opt/scripts/lin_management_console/work/tmp_file.txt

			exit	

		fi

	else

		echo "input container id to run this function"
		echo "scriptname <listtomcatservices> <cid>"
                echo "input container id to run this function" > /opt/scripts/lin_management_console/work/tmp_file.txt
                echo "scriptname <listtomcatservices> <cid>" > /opt/scripts/lin_management_console/work/tmp_file.txt


		exit

	fi


else


	echo "invalid input"
	echo "pass me listclient or listtomcatservices <container id>"
        echo "invalid input" > /opt/scripts/lin_management_console/work/tmp_file.txt
        echo "pass me listclient or listtomcatservices <container id>" > /opt/scripts/lin_management_console/work/tmp_file.txt



	exit
fi
