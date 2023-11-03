#!/bin/bash
#Sandy
#this will execute the command from the LX portal
base_dir=/opt/scripts/LX_management_console
NOW=`date +%F" "%T`

server_name=$1
UserName=$2
ScriptName=$3
Action=$4

if [ "${server_name}" ] && [ "${UserName}" ]&& [ "${ScriptName}" ] && [ "${Action}" ]; then
is_comm=`echo ${ScriptName} | grep lxcom`
is_dbcd=`echo ${ScriptName} | grep dbcd`
is_dbcfs=`echo ${ScriptName} | grep dbcfs`


		

			ssh root@${server_name} "/opt/scripts/LX_management_console/bin/CommandExecuter.sh ${UserName} ${ScriptName} ${Action}"


else
        echo "Syntax error"
        echo "usage: ./script server_name username ClientName ScriptName Action"
        echo "Example: ./CommandExecuter.sh asp1m username dbcd_aba start"
        exit
fi

