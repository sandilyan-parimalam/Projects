#!/bin/bash
#Author: Sandy
#Desc:This script will backup all the LX servers log history


hosts="asp1m asp2m ncalivenew alicolive aiglive ihcuat asptest1n asptest2n ncatestn alicotest aigtestnew"
#hosts="asptest1n"
backup_dir="/opt/backup/eh-portal_backup/LX_Report_History"

if [ "${hosts}" ] && [ "${backup_dir}" ] ; then

for i in ${hosts}
do

function PrepareBackup(){

ssh root@${i} <<SESSION

host_name=\`hostname\`
echo "backup up the logs from \$host_name"

if [ -d /opt/scripts/LX_management_console/work/ ] ; then
 
	cd /opt/scripts/LX_management_console/work/
	if [ \$? -eq 0 ] ; then
		
		if [ -d backup ] ; then rm backup/*.html ; else mkdir backup;fi

			find . -iname "*.html" -mtime -1 -exec cp -a --parents -t backup/ "{}" \+
			if [ \$? -eq 0 ] ; then
			
				cd backup
				if [ \$? -eq 0 ] ; then

					tar -cvzf report-backup-\`date +%F\`.tgz *.html 
					if [ \$? -eq 0 ] ; then
			
						echo "\`date +%F\` backup prepared \$host_name"
						rm *.html

					else

						echo "\`date +%F\` unable to tar files on \$host_name"

					fi

				else

					echo "\`date +%F\` unable to switch directory to \$host_name"

				fi

			else

				echo "\`date +%F\` find command failed on \$host_name"

			fi

	else
	
		echo "\`date +%F\` unable to switch directory to /opt/scripts/LX_management_console/work/ on \$host_name"
	fi
else

	echo "`date +%F` /opt/scripts/LX_management_console/work/ not found on ${hosts}"

fi
SESSION


}




function SCPBackup() {

if [ ! -d "${backup_dir}" ] ; then mkdir "${backup_dir}"  ; fi


	if [ ! -d "${backup_dir}/${i}" ] ; then mkdir "${backup_dir}/${i}" ; fi

	scp ${i}:/opt/scripts/LX_management_console/work/backup/report-backup-`date +%F`.tgz ${backup_dir}/${i}/
	if [ $? -eq 0 ] ; then

		echo "`date +%F` Report backup completed for ${i} "

	else

		echo "`date +%F` unable to scp backup file from ${i} to local, Report Backup failed.."

	fi


}


PrepareBackup
SCPBackup


done

else


	echo "`date +%F` host or backup dir varriable is empty in script, please set it up and run me"
fi
