#!/bin/bash
#Author:sandy
#Desc:this script will clean an year older trace logs backup 

trace_log_backup_dir="/opt/backup/eh-portal_backup/trace_logs_backup"
LX_log_backup_dir="/opt/backup/eh-portal_backup/LX_Report_History"


function clean_trace_logs() {

if [ -d "${trace_log_backup_dir}" ] ; then

	cd ${trace_log_backup_dir}
	if [ $? -eq 0 ] ; then
		find ${trace_log_backup_dir}  -mindepth 1 -mtime +360 -print -delete
	        echo "`date +%F` Trace Logs Cleanup -  completed"
	else

		echo "`date +%F`  Trace Logs Cleanup - unable to switch directory"
		exit

	fi
else

        echo "`date +%F`  Trace Logs Cleanup - error - backup dir not found"
        exit

fi


}



function clean_LX_logs() {

if [ -d "${LX_log_backup_dir}" ] ; then

        cd ${LX_log_backup_dir}
        if [ $? -eq 0 ] ; then
                find ${LX_log_backup_dir} -mtime +360 -print -delete
                echo "`date +%F` LX Logs Cleanup - leanup completed"
        else

                echo "`date +%F` LX Logs Cleanup - unable to switch directory"
                exit

        fi
else

        echo "`date +%F` LX Logs Cleanup - error - backup dir not found"
        exit

fi


}

clean_trace_logs
clean_LX_logs



