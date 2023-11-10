#!/bin/bash
#Sandy
#this will execute the command from the LX portal
base_dir=/opt/scripts/tpp_portal_scripts

Project=`echo ${1} | cut -d "_" -f1 | tr A-Z a-z`
Level=`echo ${1} | cut -d "_" -f2 | tr A-Z a-z`
Type=`echo ${1} | cut -d "_" -f3 | tr A-Z a-z`
Instance=`echo ${1} | cut -d "_" -f4 `
Action=`echo ${1} | cut -d "_" -f5 | tr A-Z a-z`
FTPPath=`echo ${@} | cut -d " " -f3`
FileName=`echo ${@} | cut -d " " -f4`


function PreCheck() {

if [  -d ${base_dir} ] ; then

	if [ ! -z "${Project}" ] || [ ! -z "${Level}" ] || [ ! -z "${Type}" ] || [ ! -z "${Instance}" ] || [ ! -z "${Action}" ] ;  then

		NOW=`date +%F"-"%m-%S`
		LogName="${NOW}.log"
		LogDir="${base_dir}/Logs/${Project}/${Level}/${Type}"
		mkdir -p ${LogDir}
		Log=${LogDir}/${LogName}
	else

		echo "ERR: required Input not detected"
		exit

	fi

else
	echo "ERR: Please input a valid base_dir on CommandExecuter.sh"
	exit

fi



}


function CheckPatch() {

echo "Under Construction"





}




function HandleInput() {
if [ "${Instance}" == "All" ] ; then

	 node_count=`grep -i "${Project}_${Level}_${Type}_node_count" ${base_dir}/bin/TPPPortal.conf | cut -d "=" -f2`
	for ((i=1;i<=node_count;i++))
	do

		Node_No="node${i}"
	        ServerIP=`grep -i "${Project}_${Level}_${Type}_${Node_No}_ip" ${base_dir}/bin/TPPPortal.conf | cut -d "=" -f2`
                Instance=`grep -i "${Project}_${Level}_${Type}_node${i}_instance_name" ${base_dir}/bin/TPPPortal.conf | cut -d "=" -f2`

		echo -e "\n----------------------------------- Processing on ${Type} Node${i} ${Instance} (${ServerIP})-----------------------------------------------------"
	        ssh root@${ServerIP} "export script\=\`ls /opt/*/scripts/maintenance_scripts/menu.sh | head -1\`;/bin/bash \$script ${Instance} ${Action} ${FTPPath} ${FileName}"


	done

else

	Node_No=`echo ${Instance} | cut -d "-" -f1`
        ServerIP=`grep -i "${Project}_${Level}_${Type}_${Node_No}_ip" ${base_dir}/bin/TPPPortal.conf | cut -d "=" -f2`
	Instance=`echo ${Instance} | cut -d "-" -f2`
        ssh root@${ServerIP} "export script\=\`ls /opt/*/scripts/maintenance_scripts/menu.sh | head -1\`;/bin/bash \$script ${Instance} ${Action} ${FTPPath} ${FileName}"


fi
}


PreCheck
HandleInput | tee -a ${Log}
