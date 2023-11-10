#!/bin/bash
#this script will check the user name  and password 

username=$1
password=$2
password_file=/etc/lin_management_users



if [ "${username}" ] && [ "${password}" ]; then


	grep "user=${username}" $password_file >> /dev/null
	if [ $? -eq 0 ] ; then
	
		stored_password=`cat $password_file | grep "${username}_password" | cut -d "=" -f2`
		if [ "${stored_password}" == "${password}" ] ; then

			echo success

		else

			echo "Wrong Password"
			exit

		fi


	else

		echo "Wrong user name"
		exit
	fi

else


	echo "Need user name and password to check"
	exit

fi
