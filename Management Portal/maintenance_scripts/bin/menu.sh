#!/bin/bash
#Sandy HSG
#This script will can help you to stop, start , restart and LIN deployments on all the Running containers





base_dir="/opt/scripts/maintenance_scripts"

echo "

        Welcome to the mytestorg Health Maintenance Script
        ----------------------------------------------
        ---------------------------------------------


Below are the available clients for Maintenance 
================================================
"
PS3='Enter the Client number: '
select client in $( vzlist | grep running | grep -v train | rev | acol 1 | rev | cut -d "." -f1 | sed 's#www##g' ); do

if [ ! -z $client ] ; then
	cid=`vzlist | grep $client | grep -v grep | head -1 |acol 1`
        if [ ! -z $cid ] ; then
                break
        else
                echo "Unable to find the container ID with the hostname of $client,  please check. .."
                exit
        fi
else
        echo "Invalid input, Please try again.."
        exit
fi
done




if [ ! -z "$cid" ] ; then

	if [ -f /vz/root/${cid}/opt/scripts/maintenance_scripts/bin/menu.sh ] ; then
		vzctl exec $cid "/opt/scripts/maintenance_scripts/bin/menu.sh"
	else
		if [ -f ${base_dir}/repo/menu.sh ] ; then
			cp -pf ${base_dir}/repo/menu.sh /vz/root/${cid}/opt/scripts/maintenance_scripts/bin/menu.sh
	                vzctl exec $cid '/opt/scripts/maintenance_scripts/bin/menu.sh'

		else
			echo "Some how the  menu.sh script was removed, place the script into /opt/scripts/maintenance_scripts/repo and run me agin.."
			exit
		fi 
	fi

else
echo "selected container is not valid"
fi

