#!/bin/bash
#Author:sandy
#Desc:this script will backup trace log

trace_log="/var/www/eh-portal/logs/trace_action.log"
backup_dir="/opt/backup/eh-portal_backup/trace_logs_backup"
backup_name=trace_log-`date +%F-%H-%M-%S`-backup

if [ -f "${trace_log}" ] && [ -d "${backup_dir}" ] && [ "${backup_name}" ]; then

	cat  ${trace_log} | grep `date +%F` > ${backup_dir}/${backup_name}
	gzip -9 ${backup_dir}/${backup_name}
	chown www-data:www-data ${backup_dir}/${backup_name}
	echo "`date +%F` backup completed"

else

	echo "`date +%F` error - log not found or varriables are not proper"
	exit

fi

