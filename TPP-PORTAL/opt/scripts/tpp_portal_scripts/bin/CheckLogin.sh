#!/bin/bash
#this script will check the user name  and password 

username=$1
password="$2"
#password=`echo ${password} | sed 's#\$#\\$#g'`

if [ "${username}" ] && [ "${password}" ]; then

		check_login=`sshpass -p "${password}" ssh ${username}@localhost 'whoami;exit '`	
		echo $check_login

		if [ "${check_login}" == "${username}" ] ; then

			echo "success"
		else

			echo "failed"
		fi

else


	echo "Need user name and password to check"
	exit

fi
