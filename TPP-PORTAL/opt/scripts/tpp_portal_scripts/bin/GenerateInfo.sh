#!/bin/bash
#Sandy
#this script will collect all the instance info based on the conf

base_dir=/opt/scripts/tpp_portal_scripts
Now=`date +%F_%H-%M-%S`


function PreCheck() {

if [  -f "${base_dir}/bin/TPPPortal.conf" ] ; then

	source "${base_dir}/bin/TPPPortal.conf"

fi

if [ ${1} ] ; then

	env="${1}"
	is_valid_env=`echo ${envs} | grep ${env}`
	 if [ -z "${is_valid_env}"  ] ; then
		echo "given env is not in conf"
		exit
	fi
else

	echo "Need env name as input"
	exit

fi
}

function Fetch(){

echo "	<div id=div_env>" >> ${base_dir}/work/NewReport_${Now}.html
	levels=$(eval 'echo $'${env}_levels)
	TypeList=""
	for level in ${levels}
	do
echo "		<div id=div_level >
		<p id=div_level_title>${level}</p>" >> ${base_dir}/work/NewReport_${Now}.html
		types=$(eval 'echo $'${env}_${level}_types)
                                JbossInstanceList=""
                                IhubInstanceList=""
			        TypeList=""
			for type in ${types}
			do
				TypeList="${TypeList} <option id=${env}_${level}_${type}>${type}</option>"
echo "				<div id=div_type>
				<center><p id=div_type_title>${type}</p></center>
				<table name=core_info>
				<tr><td> Node No </th><td> Server Name </th><td> IP </th><td> Instance Name </th> <td> Status </th></tr> " >> ${base_dir}/work/NewReport_${Now}.html
				node_count=$(eval 'echo $'${env}_${level}_${type}_node_count)
				for ((i=1;i<=node_count;i++))
				do									
					SERVER_IP=$(eval 'echo $'${env}_${level}_${type}_node${i}_ip)
					SERVER_NAME=$(eval 'echo $'${env}_${level}_${type}_node${i}_server_name)
					INSTANCE_NAME=$(eval 'echo $'${env}_${level}_${type}_node${i}_instance_name)
					STARTUP_SCRIPT=$(eval 'echo $'${env}_${level}_${type}_node${i}_startup_script)
					INSTANCE_STATUS=`ssh root@${SERVER_IP} ps -aef | grep java | grep ${INSTANCE_NAME} | grep -v grep | awk '{print $2}'`


					if [ "${type}" == "jboss" ] ; then
	                                        JbossInstanceList="${JbossInstanceList} <option id=${env}_${level}_${type}_${INSTANCE_NAME}>Node${i}-${INSTANCE_NAME}</option>"
					else
        	                                IhubInstanceList="${IhubInstanceList} <option id=${env}_${level}_${type}_${INSTANCE_NAME}>Node${i}-${INSTANCE_NAME}</option>"
					fi

					if [ "${type}" == "jboss" ] && [ ${i} -eq 2 ]; then
                                                JbossInstanceList="${JbossInstanceList} <option id=${env}_${level}_${type}_all>All</option>"
					fi

                                        if [ "${type}" == "ihub" ] && [ ${i} -eq 2 ]; then

                                                IhubInstanceList="${IhubInstanceList} <option id=${env}_${level}_${type}_all>All</option>"

					fi
				

					if [ ! -z "${INSTANCE_STATUS}" ] ; then
						INSTANCE_STATUS="<p id=status_up><font color=green><b>UP</font></b></p>"
					else
						INSTANCE_STATUS="<p id=status_down><font color=red><b>Down</b></font></p>"
					fi
echo "					<tr><td> ${i} </td><td> ${SERVER_NAME} </td><td> ${SERVER_IP} </td><td> ${INSTANCE_NAME} </td><td> ${INSTANCE_STATUS} </td></tr> " >> ${base_dir}/work/NewReport_${Now}.html
				done



echo "				</table></div>" >> ${base_dir}/work/NewReport_${Now}.html
			done
echo "			<div id=div_control><center>
				<form onsubmit=\"Go('${env}_${level}');return false;\">
				<p id=div_controller>Service Handler</p>
					<select id=${env}_${level}_ActionList onChange=LoadInstanceTypeList('${env}_${level}')>
						<option selected disabled> Select Action </option>
						<option id=Stop> Stop An Instance </option>
                                                <option id=Start> Start An Instance </option>
                                                <option id=Restart> Restart An Instance </option>
                                                <option id=bundlestatus> Check Bundle Status </option>
                                                <option id=Patching> Apply Patch </option>
                                                <option id=Revert>Revert Patch </option>
                                                <option id=Deploy> Deploy Build </option>


					</select>

					<select id=${env}_${level}_InstanceTypeList onChange=LoadInstanceList('${env}_${level}') style='display: none;'>
                                                <option selected disabled> Select Instance Type </option>
						${TypeList}

					</select>

                                        <select id=${env}_${level}_jboss_InstanceList style='display: none;'onChange=ShowGo('${env}_${level}')>
                                                <option selected disabled> Select instance Name </option>
						${JbossInstanceList}
                                        </select>

                                        <select id=${env}_${level}_ihub_InstanceList style='display: none;' onChange=ShowGo('${env}_${level}')>
                                                <option selected disabled> Select instance Name </option>
                                                ${IhubInstanceList}
                                        </select>
					<input type=text id=${env}_${level}_FTP_Path style='display: none;' placeholder=\"Enter FTP Path\" Required  disabled />
                                        <input type=text id=${env}_${level}_FileName style='display: none;' placeholder=\"Enter File Name\" Required  disabled />
					<input type=submit id=${env}_${level}_submit style='display: none;' value=GO />



			</form></center></div>" >> ${base_dir}/work/NewReport_${Now}.html
echo "  </div>" >> ${base_dir}/work/NewReport_${Now}.html

		done

echo "  </div>" >> ${base_dir}/work/NewReport_${Now}.html

}


PreCheck $1
Fetch
cat ${base_dir}/work/NewReport_${Now}.html

