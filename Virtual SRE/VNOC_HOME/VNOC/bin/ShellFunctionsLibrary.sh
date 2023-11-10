#!/bin/bash
#Author:sandilyan.parimalam@mytestorg.com
#From:HSG@mytestorg.com
#Description: This is shell script contains the function which is often usable by common shell scripts. 
#ConfDir and ConfFileName are mandatory variables on this , make sure they are set correctly
#you can call it though any shell scripts by executing this script before calling any functions

#Available Functions with syntax
#------------------------------
#CheckVariable VariableName=$variable
#LoadConfig
#CheckFileAvailability file
#CheckFilePermission file
#CheckEmptyFile file
#CheckDirAvilability dir
#Initialize
#CheckNMkdir dir
#CheckHostAvailability <IP>
#CheckHostLogin <IP>
#LogFile="Log file name woth path";log <content>
#----------------------------------


BaseDir="${HOME}/VNOC"
ConfDir="${BaseDir}/conf"
ConfigFile="${ConfDir}/VNOC.conf"
LogDir="${BaseDir}/logs"
WorkDir="${BaseDir}/work"
TmpDir="${WorkDir}/tmp"
BackupDir="${BaseDir}/backup"
ParrentScript=`caller|awk '{print $2}'`


function Initialize() {

echo -n "Initializing - "

CheckDirAvilability ${BaseDir}
CheckDirAvilability ${ConfDir}
CheckEmptyFile ${ConfigFile}
. ${ConfigFile}
CheckNMkdir ${LogDir}
CheckNMkdir ${WorkDir}
CheckNMkdir ${BackupDir}
echo "Done"
}

function CheckVariable() {

Variable="${@}"

if [ "${Variable}" ] ; then

	VariableName=`echo ${Variable} | cut -d "=" -f1`
	Variable=`echo ${Variable} | cut -d "=" -f2`
	if [ ! "${Variable}" ] ; then

        	echo "Error Occurred"
	        echo "ERR Info: An Empty Mandatory Variable found"
		echo "ERR Info: Given Variable Name: \${${VariableName}}"
	        echo "ERR Info: Parrent Script:${ParrentScript}"
	        echo "ERR Info: Terminating Script Execution"
	        exit
	fi
else

	echo "Error Occurred"
	echo "ERR Info: CheckVariable function initiated without proper input"
	echo "ERR Info: Parrent Script:${ParrentScript}"
	echo "ERR Info: Terminating Script Execution"
	exit
  

fi

}


function CheckFileAvailability() {

#About: This Function will check given file is avilable. 

file="${1}"

if [ "${file}" ] ; then

		if [ ! -f "${file}" ]; then


		        echo "Error Occurred"
		        echo "ERR Info: Madatory file not found"
		        echo "ERR Info: File ${file}"
		        echo "ERR Info: Parrent Script:${ParrentScript}"
		        echo "ERR Info: Terminating Script Execution"
		        exit

		fi
else

        echo "Error Occurred"
        echo "ERR Info: File Check called without giving file name"
	echo "ERR Info: Parrent Script:${ParrentScript}"
        echo "ERR Info: Terminating Script Execution"
        exit

fi

}


function CheckFilePermission() {

#About: This Function will check given file avilable and readable by the user.


file="${1}"
CheckFileAvailability "${file}"
if [ ! -r "${file}" ] ; then

        echo "Error Occurred"
        echo "ERR Info: Insufficient permission to read a mandatory file"
        echo "ERR Info: File ${file}"
        echo "ERR Info: Parrent Script:${ParrentScript}"
        echo "ERR Info: Terminating Script Execution"
        exit
fi

}



function CheckEmptyFile() {

#About: This Function will check given file avilable,readable by the user and size is not 0

file="${1}"
CheckFileAvailability "${file}"
CheckFilePermission "${file}"
if [ ! -s "${file}" ] ; then

        echo "Error Occurred"
        echo "ERR Info: Empty mandatory file"
        echo "ERR Info: File ${file}"
        echo "ERR Info: Parrent Script:${ParrentScript}"
        echo "ERR Info: Terminating Script Execution"
        exit
fi


}


function CheckDirAvilability() {

Dir="${1}"

if [ "${Dir}" ] ; then

	if [ ! -d "${Dir}" ]; then
	        echo "Error Occurred"
	        echo "ERR Info: Madatory Dir not found"
	        echo "ERR Info: Dir ${Dir}"
	        echo "ERR Info: Parrent Script:${ParrentScript}"
	        echo "ERR Info: Terminating Script Execution"
	        exit
	fi

else

        echo "Error Occurred"
        echo "ERR Info: CheckDirAvilability function called without passing any input'"
        echo "ERR Info: Parrent Script:${ParrentScript}"
        echo "ERR Info: Terminating Script Execution"
        exit


fi


}


function CheckNMkdir() {


Dir="${1}"

if [ "${Dir}" ] ; then
	if [ ! -d "${Dir}" ] ; then
		mkdir "${Dir}" >> /dev/null 2>&1
		RCode=${?}
		if [ ${RCode} -ne 0 ] ; then
		        echo "Error Occurred"
		        echo "ERR Info: Unable to create a Madatory Dir"
		        echo "ERR Info: Dir Name = ${Dir}"
		        echo "ERR Info: Parrent Script:${ParrentScript}"
		        echo "ERR Info: Terminating Script Execution"
		        exit

		fi
	fi
else

        echo "Error Occurred"
        echo "ERR Info: CheckNMkdir function called without passing any input'"
        echo "ERR Info: Parrent Script:${ParrentScript}"
        echo "ERR Info: Terminating Script Execution"
        exit


fi

}

function log() {


LogContent="${@}"

if [ ! -z "${LogFile}" ]; then

	if [ -f "${LogFile}" ] ; then
	
		CheckFilePermission "${LogFile}"
		echo "`whoami` `date` ${LogContent}" >> "${LogFile}"
	else
		echo "INFO : Creating log file ${LogFile}"
                echo "`whoami` `date` ${LogContent}" > "${LogFile}"

	fi
	

else

        echo "Error Occurred"
        echo "ERR Info: log function called without passing proper log name"
        echo "ERR Info: Make sure LogFile varriable is loaded with log file with path and call the function as below"
	echo "log <log content>"
        echo "ERR Info: Parrent Script:${ParrentScript}"
        echo "ERR Info: Terminating Script Execution"
        exit

fi
}

function CheckHostAvailability() {
IP="${1}"
CheckVariable IP=${IP}
echo -ne "\nChecking ${IP} Availability - "
PacketLoss=`ping -c 5 ${IP} | grep "packet loss" | cut -d "," -f3 | cut -d "%" -f1 | sed 's# ##g'`
CheckVariable PacketLoss=${PacketLoss}

if [ "${PacketLoss}" == "100" ] ; then

	echo "[Host is not responding]"
        echo "ERR Info: Parrent Script:${ParrentScript}"
        echo "ERR Info: Terminating Script Execution"
        exit

else
        echo -e "[Host is UP]\n"
	
fi


}


function CheckHostLogin() {

IP="${1}"
CheckVariable IP=${IP}
echo -ne "\nChecking ${IP} Login - "

PacketLoss=`ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null 10.200.20.100 'ifconfig | grep "${IP}" |cut -d ":" -f2 |cut -d " " -f1' 2> /dev/null`
CheckVariable PacketLoss=${PacketLoss}

if [ "${PacketLoss}" != "${PacketLoss}" ] ; then

        echo "[Host is not Allowing to login]"
	echo "ERR Info: make sure the user is exist on target server and password less ssh is enabled"
        echo "ERR Info: Parrent Script:${ParrentScript}"
        echo "ERR Info: Terminating Script Execution"
        exit

else
        echo -e "[Success]\n"

fi


}

