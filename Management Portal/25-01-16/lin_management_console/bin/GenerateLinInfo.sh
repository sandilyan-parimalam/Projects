#!/bin/bash
#Sandy
#this will all the informations about LINs
base_dir=/opt/scripts/lin_management_console


function PreCheck() {

export PATH=$PATH:/usr/local/bin//usr/local/bin/acol

if [ ! -d ${base_dir} ] ; then echo "base_dir is not proper, Please correct and try again" ; fi
if [ ! -d ${base_dir}/work ] ; then mkdir ${base_dir}/work ; else rm ${base_dir}/work/* -rf ; fi

}


function BeginReport() {

echo "
<table>
<tr><td rowspan=2><b> Client  </td> <td rowspan=2><b>  Service Details </td> <td colspan=3 ><b> Container Details </td></tr>
<tr><td ><font color=blue><b><i>Container</td> <td><font color=blue><b><i>Space</td> <td><font color=blue><b><i> Performance </td></b></font> </tr>
" > ${base_dir}/work/NewReport.html



}


function AppendData() {

for i in ` vzlist -a | /usr/local/bin/acol 1 | grep -v CTID`
do

function ContainerInfo() {
CID="NA"
CNAME="NA"
CSTATE="NA"
Service_Status=""
ClientName="NA"
SEC_MEM="Total: NA
Used : NA
Free : NA
Used : NA
Free : NA"

UPTIME="NA"
IP="NA"
space="NA"
CPU="NA"
SWAP="NA"

CID=`vzlist -a | grep ${i} | head -1 | /usr/local/bin/acol 1`
CNAME=`vzlist -a | grep ${i} | head -1|rev | /usr/local/bin/acol 1 | rev`
CSTATE=`vzlist -a | grep ${i} | head -1 | /usr/local/bin/acol 3`
ClientName=`vzlist -a | grep ${i} | head -1|rev | /usr/local/bin/acol 1 | rev | cut -d "." -f1 `


if [ "${CSTATE}" == "running" ] ; then
	SEC_MEM=`vzctl exec ${CID} 'free -m'`
	SEC_MEM=`echo "$SEC_MEM" | head -2 | tail -1 | awk '{print "Total: "$2 "\nUsed : "$3 "\nFree : "$4}'`
	UPTIME=`vzctl exec ${CID} 'uptime' | awk '{print $3" Days"}'`
	IP=`vzctl exec ${CID} 'ifconfig' | grep inet | grep 10. | head -1 | awk '{print $2}' | cut -d ":" -f2`
	space=`vzctl exec ${CID} 'df -h'`
	CPU=`vzctl exec ${CID} 'top -bn1 | head -8 | tail -1'`
	CPU=`echo "${CPU}" | /usr/local/bin/acol 9` ; CPU="$CPU %"
	SWAP=`vzctl exec ${CID} 'free -m |  tail -1'`
	SWAP=`echo $SWAP | awk '{print $2}'`
fi



}


function ServicesInfo() {
> ${base_dir}/work/tmp.txt
if [ "${CSTATE}" == "running" ] ; then
for i in `ls /vz/root/${CID}/etc/init.d/ | egrep  '^apache|lin|^keepalive*' | egrep -v 'old|don|not|bkp|backup|z'| sed 's#test_lin#tomcat_test#g' | sed 's#apache#apache/tomcat#g'| sort`
do

Service_Name=$i
if [ "$Service_Name" == "apache/tomcat" ] ; then
	Service_Name=apache
	Service_Status=`vzctl exec ${CID} "/opt/scripts/maintenance_scripts/bin/menu.sh status $Service_Name | grep Apache | grep UP"`
	if [ ! -z "$Service_Status" ] ; then
		apache_status="<font color=green size=3><b>UP<br><input type=button class=myButton onclick=PopUp('${ClientName}','${CID}','${Service_Name}','stop') value=' Stop Apache '/> <input type=button onclick=PopUp('${ClientName}','${CID}','${Service_Name}','restart') value='Restart Apache' /></b></font><br>"

	else
		apache_status="<font color=red size=3><b>DOWN<br><input type=button onclick=PopUp('${ClientName}','${CID}','${Service_Name}','start') value=' Start Apache '/></font><br>"
	fi

        Service_Status=`vzctl exec ${CID} "/opt/scripts/maintenance_scripts/bin/menu.sh status $Service_Name | grep Tomcat | grep UP"`
        if [ ! -z "$Service_Status" ] ; then
                tomcat_status="<font color=green size=3><b>UP<br><input type=button onclick=PopUp('${ClientName}','${CID}','${Service_Name}','stop') value=' Stop Tomcat '/> <input type=button onclick=PopUp('${ClientName}','${CID}','${Service_Name}','restart') value='Restart Tomcat' /></b></font><br>"
        else
               tomcat_status="<font color=red size=3><b>DOWN<br><input type=button onclick=PopUp('${ClientName}','${CID}','${Service_Name}','start') value=' Start Tomcat '/></font><br>"
        fi
echo "<p align=center>Apache is  $apache_status<br>Tomcat is $tomcat_status" >> ${base_dir}/work/tmp.txt

else

	Service_Status=`vzctl exec ${CID} "/opt/scripts/maintenance_scripts/bin/menu.sh status $Service_Name | grep UP"`
        if [ ! -z "$Service_Status" ] ; then
                status="<font color=green size=3><b>UP<br><input type=button onclick=PopUp('${ClientName}','${CID}','${Service_Name}','stop') value=' Stop ${Service_Name} '/> <input type=button onclick=PopUp('${ClientName}','${CID}','${Service_Name}','restart') value='Restart ${Service_Name} ' /></b></font><br>"
        else
                status="<font color=red size=3><b>DOWN<br><input type=button onclick=PopUp('${ClientName}','${CID}','${Service_Name}','start') value=' Start ${Service_Name} '/></font><br>"
        fi
echo "${Service_Name} is ${status}" >> ${base_dir}/work/tmp.txt


fi


done

else

echo "<p align=center >Not Available </p>" > ${base_dir}/work/tmp.txt
fi

}

function AppendHtml() {

echo "
<tr>

<td><pre>
Client Name : ${ClientName}<br>
URL         : <a href=https://${ClientName}.mytestorghealth.com target=_blank>${ClientName}.mytestorghealth.com
</a>
</pre> </td> 
<td ><pre>`cat ${base_dir}/work/tmp.txt`</p></pre></td>

<td>
<pre>
Container ID	 : ${CID} 
Container Name	 : ${CNAME} " >> ${base_dir}/work/NewReport.html

if [ "${CSTATE}" != "running" ] ; then
link_cstate=`echo "${CSTATE} <input type=button onclick=ManageContainer('${CID}','${CNAME}','${CSTATE}') value=' Start Me '/>"`
else
link_cstate=${CSTATE}
fi

echo "Container Status : ${link_cstate}
IP Address       : ${IP}
Uptime		 : ${UPTIME}
</pre>
</td> 

<td>
<pre>
${space}
</pre>
</td>

<td>
<pre>
CPU	: ${CPU}
<b>Secondary Memory</b>
$SEC_MEM
Swap : $SWAP
</pre>
</td>



</tr>
" >> ${base_dir}/work/NewReport.html 

}
ContainerInfo
ServicesInfo
AppendHtml


done

}

function EndReport() {


echo "
</table> 
"
>> ${base_dir}/work/NewReport.html

}




PreCheck
BeginReport
AppendData
EndReport
cat ${base_dir}/work/NewReport.html

