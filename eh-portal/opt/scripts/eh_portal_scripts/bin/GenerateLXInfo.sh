#!/bin/bash
#Sandy
#this will collect all the informations about LX clients
base_dir=/opt/scripts/LX_management_console
datentime=`date +%F_%H-%M-%S`

function PreCheck() {

export PATH=$PATH:/usr/local/bin//usr/local/bin/acol

if [ ! -d ${base_dir} ] ; then echo "base_dir is not proper, Please correct and try again" ; fi
if [ ! -d ${base_dir}/work ] ; then mkdir ${base_dir}/work ; fi

}


function BeginReport() {

echo "
<table>
<thead>
<tr>
	<th> Client  </th>
	<th> DBC     </th>
	<th> DBCFS   </th>
	<th> HIPAA   </th>
	<th> COMM    </th>
	<th> Socket  </th>
	<th> Folio   </th>
	<th> Service Handler </th>
</tr>
</thead>
" >  ${base_dir}/work/NewReport_${datentime}.html



}


function GatherDetails() {

for i in `ls /etc/init.d/dbcd_* | egrep -v 'backup|bkp|tmp|old|not|use' | cut -d "_" -f2 | sort`
do

client_name=${i}


#	Flusing the varribles

DBCD_PID=""
DBCD_status=""
DBCD_status_shell=""

DBCFS_PID=""
DBCFS_status=""
DBCFS_count=""
DBCFS_status_shell=""

HIPAAs=""
HIPAA_status=""
HIPAA_status_shell=""

COMM_con_count=""
COMM_status=""
COMM_status_shell=""

SOCKET_PID=""
SOCKET_status=""
SOCKRT_status_shell=""

FOLIO_PID=""
FOLIO_status=""
FOLIO_status_shell=""


function GetDBCInfo() {

DBCD_PID=`ps -ef | grep "^${client_name}" | grep "dbcd -y" | grep -v grep | awk '{print $2}'`

if [ ! -z "${DBCD_PID}" ] ; then

	DBCD_status="<font color=green> UP </font>"

	DBCD_status_shell=up:
else

        DBCD_status="<font color=red>Down</font>"
        DBCD_status_shell=down:
	
fi


}



function GetDBCFSInfo() {

if [ -f /etc/init.d/dbcfs_${client_name} ] ; then

	DBCFS_PID=`ps -ef | grep "^${client_name}" | grep "dbcfs -cfg" | grep -v grep | awk '{print $2}'`

	if [ ! -z "${DBCFS_PID}" ] ; then

        	DBCFS_status="<font color=green>UP</font>"
		DBCFS_status_shell=up:
	        DBCF_count=` ps -ef | grep "^${client_name}" | grep "sport" | egrep -v 'dbcfs -cfg|dbcd -y' | grep -v grep | wc -l`

	else

        	DBCFS_status="<font color=red>Down</font>"
		DBCFS_status_shell=down:
		DBCF_count=""
	fi

else

	DBCFS_status=NA
        DBCF_count=""
	


fi

}




function GetHIPAAInfo() {

HIPAAs=`ls /etc/init.d/hipaa_* | grep "hipaa_${client_name}" | egrep -v 'grep|old|backup|tmp|not|use|bk' | cut -d "_" -f2`

if [ ! -z "${HIPAAs}" ] ; then
	for o in `echo $HIPAAs`
	do

		PID=""
		PID=`ps -ef | grep "startup ${o} issued by" | grep -v grep | awk '{print $2}'`
		if [ ! -z "$PID" ] ; then
			HIPAA_status_shell="${HIPAA_status_shell} ${o}_up:"
                        HIPAA_status="${HIPAA_status} <br> ${o} is <font color=green>UP</font>"


		else

			HIPAA_status_shell="${HIPAA_status_shell} ${o}_down:"
			HIPAA_status="${HIPAA_status} <br> ${o} is <font color=red>Down</font>"		

		fi
	
	done

else

	HIPAA_status=NA

fi

}





function GetSOCKETInfo() {

if [ -f /etc/init.d/socketserver_${client_name} ] ; then

	SOCKET_PID=`ps -ef | grep "^${client_name}" | grep SocketServer | awk '{print $2}'`
	if [ ! -z "${SOCKET_PID}" ] ; then

	        SOCKET_status="<font color=green>UP</font>"
		SOCKET_status_shell=up:
	else

        	SOCKET_status="<font color=red>Down</font>"
		SOCKET_status_shell=down:
	fi

else

        SOCKET_status="NA"


fi

}




function GetFOLIOInfo() {

if [ -f /etc/init.d/folio_${client_name} ] ; then

	FOLIO_PID=`ps -ef | grep "^${client_name}" | grep folio | awk '{print $2}'`
		if [ ! -z "${FOLIO_PID}" ] ; then

		        FOLIO_status="<font color=green>UP</font>"
			FOLIO_status_shell=up:
	else

        	FOLIO_status="<font color=red>Down</font>"
		FOLIO_status_shell=down:
	fi

else

	FOLIO_status=NA

fi


}




function GetCOMMInfo() {

COMMs=""
COMM_status=""
COMMs=`ls /etc/init.d/lxcomsvr_* | grep "lxcomsvr_${client_name}" | egrep -v 'grep|old|backup|tmp|not|use|bk' | cut -d "_" -f2`

if [ ! -z "${COMMs}" ] ; then
        for i in `echo $COMMs`
        do

                COMM_con_count=0
		grep_name=""
		client_initial=`echo "${i}" | cut -c1-3`
		grep_name=`echo "${i}" | sed "s/${client_initial}//g"`

		COMM_state_from_script=""
		COMM_configured_count=""
		COMM_running_count=""
		COMM_down_port_count=""

                COMM_state_from_script=`/etc/init.d/lxcomsvr_${i} status | tail -1 | awk '{print $4" "$5" "$6}'`
		COMM_configured_count=`/etc/init.d/lxcomsvr_${i} status | tail -1 | cut -d " " -f1-3| sed 's# ##g'`
		COMM_running_count=`/etc/init.d/lxcomsvr_${i} status | tail -1 | cut -d " " -f4-6| sed 's# ##g'`		

		COMM_down_port_count=`echo $((COMM_configured_count-COMM_running_count))`

                if [ ${COMM_down_port_count} -eq 0 ] ; then

                        COMM_status="${COMM_status} <br> ${i} is <font color=green>UP</font>  [${COMM_state_from_script}]"
			COMM_status_shell="${COMM_status_shell} ${i}_up:"


                else
			if [ "${COMM_down_port_count}" -eq "${COMM_configured_count}" ] ; then

                                COMM_status="${COMM_status} <br> ${i} is <font color=red>Down</font>"
                                COMM_status_shell="${COMM_status_shell} ${i}_down:"
                                COMM_con_count=""
			else
	                        COMM_status="${COMM_status} <br> ${i} is <font color=red>Partially Down</font>"
	                        COMM_status_shell="${COMM_status_shell} ${i}_partiallydown:"
        	                COMM_con_count=""
			fi

                fi

        done

else

        COMM_status=NA
	COMM_con_count=""
fi





}



function AppendTable() {

echo "

<tr>
	<td>
		${client_name}<br>
	</td>

	<td>${DBCD_status}</td>

	<td>${DBCFS_status}" >> ${base_dir}/work/NewReport_${datentime}.html

	if [ ! -z "${DBCF_count}" ] ; then 
		echo "<br> Connections : ${DBCF_count} </td>" >> ${base_dir}/work/NewReport_${datentime}.html
	else
                echo "</td>"  >> ${base_dir}/work/NewReport_${datentime}.html
	fi

echo "
	<td> ${HIPAA_status} </td>
	<td> ${COMM_status} </td>
	<td> ${SOCKET_status} </td>
	<td> ${FOLIO_status} </td>
	<td>

                <select id='ServiceName_${client_name}' onChange=LoadActions('$client_name');>

                        <option selected disabled>Select Service</option>
" >> ${base_dir}/work/NewReport_${datentime}.html

if [ "${DBCD_status_shell}" == "up:" ] ; then

        echo "<option value=dbcd_${client_name}_up:> DBCD </option>" >> ${base_dir}/work/NewReport_${datentime}.html
else

        echo "<option value=dbcd_${client_name}_down:> DBCD </option>" >> ${base_dir}/work/NewReport_${datentime}.html


fi

if [ "${DBCFS_status}" != "NA" ] ; then

        if [ "${DBCFS_status_shell}" == "up:" ] ; then

                echo "<option value=dbcfs_${client_name}_up:> DBCFS </option>" >> ${base_dir}/work/NewReport_${datentime}.html
        else

                echo "<option value=dbcfs_${client_name}_down:> DBCFS </option>" >> ${base_dir}/work/NewReport_${datentime}.html

        fi


fi

if [ "${HIPAA_status}" != "NA" ] ; then


        for l in `echo ${HIPAAs}`
        do
                tmp_stat=""
                tmp_stat=`for x in ${HIPAA_status_shell} ; do echo ${x} ; done | grep "${l}_" | cut -d "_" -f2| grep -v grep`

                 echo "<option value=hipaa_${l}_${tmp_stat}> HIPAA [`echo ${l} | tr 'a-z' 'A-Z' `] </option>" >> ${base_dir}/work/NewReport_${datentime}.html

        done



fi

if [ "${COMM_status}" != "NA" ] ; then

        for m in `echo ${COMMs}`
        do
                tmp_comm_stat=""
                tmp_comm_stat=`for y in ${COMM_status_shell} ; do echo ${y} ; done | grep "${m}_" | cut -d "_" -f2| grep -v grep`
                echo "<option value=lxcomsvr_${m}_${tmp_comm_stat}> COMM [`echo ${m} | tr 'a-z' 'A-Z' `] </option>" >> ${base_dir}/work/NewReport_${datentime}.html

        done

fi



if [ "${SOCKET_status}" != "NA" ] ; then

        echo "<option value=socketserver_${client_name}_${SOCKET_status_shell}> SOCKET </option>" >> ${base_dir}/work/NewReport_${datentime}.html
fi
if [ "${FOLIO_status}" != "NA" ] ; then

        echo "<option value=socketserver_${client_name}_${FOLIO_status_shell}> FOLIO </option>" >> ${base_dir}/work/NewReport_${datentime}.html
fi



echo "
                </select>
                <select id=ActionsList_${client_name} onChange=UnHideButton('button_${client_name}'); style='display: none;'>
                        <option selected disabled>Select Action </option>
                </select>
		<input type=button id=button_${client_name} value=GO onClick=Go('${client_name}'); style='display: none;'/>


	</td>

</tr>


" >> ${base_dir}/work/NewReport_${datentime}.html


}





GetDBCInfo
GetDBCFSInfo
GetHIPAAInfo
GetSOCKETInfo
GetFOLIOInfo
GetCOMMInfo
AppendTable

done


}




function EndReport() {


echo "
</table>
" >> ${base_dir}/work/NewReport_${datentime}.html

}



PreCheck
BeginReport
GatherDetails
EndReport
cat ${base_dir}/work/NewReport_${datentime}.html
