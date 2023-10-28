#!/bin/bash
#Desc:mytestorg Health Maintenance script
#Author:Sandy

basedir="/opt/scripts/maintenance_scripts"
backup_dir="/usr/local/backup"
dtf=`date +%F_%H-%M-%S`
SNAME=ftp.mytestorghealth.com
UNAME=00600
PASSWORD=RedRock22#



function PreCheck() {
if [ ! -z "$basedir" ] ; then
if [ ! -z "$SNAME" ] && [ ! -z "$UNAME" ] && [ ! -z "$PASSWORD" ]  ; then
        if [ -d "$basedir/bin" ] ; then

                if [ ! -d "$basedir/logs" ] ; then
                        mkdir $basedir/logs
                fi

		temp_dir="$basedir/work"
		if [ ! -d "$temp_dir" ] ; then
                        mkdir $temp_dir
		else
			rm -rf $temp_dir
			mkdir $temp_dir
               fi

		if [ $backup_dir ] ; then
	                if [ ! -d "$backup_dir" ] ; then
        	                mkdir $backup_dir
                	fi
		else
			echo -e  "\E[31m Please update the backup_dir in script \E[0m"
		
			exit
		fi



			ftp_log="$temp_dir/ftp.log"
		        GetInfo

        else
                echo "$basedir/bin directory is missing, Please copy the directory and files then retry.."
                exit
        fi
else

	echo "set FTP details properly in the script and try again"
	exit
fi

else

        echo "Set base dir properly and run me again"
        exit

fi
}


function GetInfo() {

function ProceedWithInteraction() {
                                                                                                #select action
echo "

Please select the action
==================
1) Check a Service
2) Stop a Service
3) Start a Service
4) Restart a Service
5) Perform LIN Update
===================
"
echo -n 'Enter the option number: '
read action

if [ ! -z "$action" ] ; then
        if [ $action -eq 1 ] ; then
                action=status
        elif [ $action -eq 2 ] ; then
                action=stop
        elif [ $action -eq 3 ] ; then
                action=start
        elif [ $action -eq 4 ] ; then
                action=restart
        elif [ $action -eq 5 ] ; then
                action=linupdate


        else
                echo "Invalid Option, Please try again"
                exit
        fi
else
        echo "Empty Input, please try again"
        exit
fi


if [ $action == "linupdate" ] ; then
LinUpdate
exit
fi


echo "
Select one of the available service 
===============================================
"
PS3='Enter the sevice number: '
select service in  $(ls /etc/init.d/ | egrep  '^apache|lin|^keepalive*' | egrep -v 'old|don|not|bkp|backup|z'| sed 's#test_lin#tomcat_test#g' | sed 's#apache#apache/tomcat#g'| sort); do
if [ ! -z $service ] ; then

	ExecuteCommand
	break

else
        echo "Invalid input, Please try again.."
        exit
fi
done

}



function ProceedWithoutInteraction() {

	ExecuteCommand

}

if [ ${type} == "auto" ] ; then

	ProceedWithoutInteraction
else
	ProceedWithInteraction
fi

}





function ExecuteCommand() {
service=`echo $service| sed 's#apache/tomcat#apache#g'`
function status() {
	
        if [ $service == apache ] ; then
		echo -e "\nChecking Apache status......"
		pid=`netstat -anp | egrep "LISTEN" | grep httpd | rev | awk '{print $1}' | rev | cut -d "/" -f1 | head -1`
		is_listen=`netstat -anp | egrep "LISTEN" | grep httpd | awk '{print $4}' | sed 's#:# #g'`
		if [ ! -z "$is_listen" ] ; then
			echo -e "\nApache is \E[32m[ UP ]\E[0m with the PID of $pid \n" 
			echo -e "Apache is \E[32m[ LISTENING ]\E[0m for the below ports"
			echo "$is_listen"
		else
			echo -e "\n Apache is \E[31m[ DOWN ]\E[0m or \E[31m[ NOT LISTENING ]\E[0m \n"
		fi

                echo -e "\nChecking Tomcat status......\n"
                pid=`ps -aef | grep /tomcat/ | grep -v grep | awk '{print $2}'`
                if [ ! -z "$pid" ] ; then
                        echo -e "Tomcat is \E[32m[ UP ]\E[0m with the PID of $pid \n"
                        exit
                else
                        echo -e "Tomcat is \E[31m[ DOWN ]\E[0m \n"
                        exit
                fi

	else
		pid=`ps -aef | grep "/${service}/" | grep -v grep | awk '{print $2}'`
                if [ ! -z "$pid" ] ; then
			echo -e "\n $service is \E[32m[ UP ]\E[0m with the PID of $pid \n"
			exit
		else

                        echo -e "\n $service is \E[31m[ DOWN ]\E[0m \n"
			exit
			 
		fi


         fi


}

function stop() {
        echo "Stopping $service ..."
        log $action $service
        sleep 2
        /etc/init.d/$service_name stop
        sleep 3
        echo -e "\nService Stopped , Please check the status and confirm.."
        exit


}

function start() {

        echo "Starting $service..."
        log $action $service
	/etc/init.d/$service_name start
        sleep 3
        echo -e "\nService Started , Please check the status and confirm.."
        exit


}
function restart() {


	        log $action $service
                echo "Stopping $service..."
	         /etc/init.d/$service_name stop
                sleep 5
                is_dead=`status | grep UP`
                if [ ! -z "$is_dead" ] ; then kill -9 $pid ; echo "process killed" ; fi
                echo "Starting $service..."
                /etc/init.d/$service_name start
                sleep 3
                echo "$service has been started, please check status and confirm...."
                exit


}


        #calling function below
service_name=`echo $service | sed 's#tomcat_test#test_lin#g'`

$action
}



function log() {

echo "`hostname` `date +%F' '%T` `whoami` $@" >> $basedir/logs/activity.log

}






function LinUpdate() {


function GetBuildInfo() {


echo -e "\nSelect the instance to perform LIN update"
PS3="Enter the instance number: "
select instance in $(ls /usr/local/ | grep ^tomcat | egrep -v 'bk|bac|old|not|dont|use|z')
do


if [ $instance ] ; then
	if [ -d "/usr/local/${instance}/webapps/lin" ] ; then
		echo -e "\nChecking instance status.....\n"
		pid=`ps -aef | grep /${instance}/ | grep -v grep | head -1 | awk '{print $2}'`
		if [ ! -z "$pid" ] ; then
		       echo -e "\E[31m Seems the instance is online, Please stop it and continue \E[0m"
			log $action $service "--> Failed --> No Changes Done"
		       exit
		else
		        echo -e "\E[32m Instace is OFFLINE, good to go... \E[0m"
		fi

		service=$instance
		break
		
	else
		echo -e "033[31m selected instance seems invalid, please select valid one.. \033[0m"
		echo -e "033[31m if you sure the selected instance is correct, examin the script... \033[0m"
		log $action $service "--> Failed --> No Changes Done"
		exit
	fi
else
        echo -e "\033[31m Empty input... \033[0m"
	log $action $service "--> Failed --> No Changes Done"
	exit
fi


done

echo
read -p "Enter the FTP Path of WAR file: " ftp_path
echo
if [ -z "$ftp_path" ] ; then
        echo -e "\033[31m Empty FTP path..... \033[0m"
	log $action $service "--> Failed --> No Changes Done"
        exit
fi

read -p "Enter the WAR file name: " file_name
echo
if [ -z "$file_name" ] ; then
        echo -e "\033[31m Empty file_name..... \033[0m \n"
	log $action $service "--> Failed --> No Changes Done"
        exit

else

        if [ ! `echo $file_name | grep -i "war"` ] ; then
                echo -e "\033[31m \n provide a valid file name with .WAR extention \033[0m \n"
		log $action $service "--> Failed --> No Changes Done"
                exit
        fi


fi
}

function Download() {

echo -e "Downloading $file_name, Please wait...........\n"
cd $temp_dir
ftp -pinv $SNAME <<End-Of-Session | tee -a $ftp_log
user $UNAME $PASSWORD
cd  "$ftp_path"
binary
tick
get "$file_name"
bye
End-Of-Session


        if [ -f "$temp_dir/$file_name" ] ; then
                echo -e "$file_name downloaded successfully...\n"
		echo -e "Checking the WAR file.......\n"
		size_of_war=`du "$temp_dir/$file_name" | awk '{print $1}'`
		if [ $size_of_war -le 0 ] ; then
			echo -e "\E[31m Seems the war file is empty, please check....\E[0m" 
			log $action $service "--> Failed --> No Changes Done"
			exit
		fi

        else
		log $action $service "--> Failed --> No Changes Done"
                if [ "`cat $ftp_log | grep -i "Not connected"`" ] ; then
                        echo -e "\033[31m Unable to connect FTP Server, please check ftp servername or ipaddress in conf file and check the FTP is UP \033[0m"
                        exit
                elif [ "`cat $ftp_log | grep -i "Login failed"`" ] ; then
                        echo -e "\033[31m Unable to login with the credentials stored in conf file, please check  the username/password or it may be changed/locked \033[0m"
                        exit
                elif [ "`cat $ftp_log | grep -i "Failed to change directory"`" ] ; then
                        echo -e "\033[31m Given FTP Path $ftp_path is not exist on FTP, please check and provide valid case sensitive path \033[0m"
                        exit
                elif [ "`cat $ftp_log | grep -i "Failed to open file"`" ] ; then
                        echo -e "\033[31m Given file name $file_name is not exist on FTP, please check and provide valid case sensitive patch name.... \033[0m"
                        exit
                else
                        echo -e "\033[31m Somehow unable to download $file_name, please check the drive space and other reasons.. Below Is the ftp log \033[0m"
                        cat $ftp_log
                        exit
                fi




        fi


}

function Backup() {

echo -e "Backing up the existing application, please wait......\n"
tar -Pcz --totals --wildcards -f ${backup_dir}/${instance}_bkp_${dtf}.tgz /usr/local/${instance}/webapps 
if [ $? -eq 0 ] ; then

	echo -e "\E[32m Backup Completed....\E[0m"
	echo -e "Backup Filename='${backup_dir}/${instance}_bkp_${dtf}.tgz' \n"

else

	echo -e "\E[31m Unable to backup the existing ${instance},Please check...terminatting \E[0m"
	log $action $service "--> Failed --> No Changes Done"
	exit

fi
}


function UpdateLin() {

cd /usr/local/${instance}/webapps/lin
if [ $? -eq 0 ] ; then
echo -e "Removing old Files, Please wait......\n"
rm -rf *.jsp 
rm -rf WEB-INF/lib/*.* WEB-INF/classes/com
if [ $? -eq 0 ] ; then

	echo -e "\E[32m Removed...... \E[0m \n"
	echo -e "Extracting the WAR file,Please wait....\n"

	/usr/local/java/bin/jar -xf "${temp_dir}/${file_name}"
	if [ $? -eq 0 ] ; then

		echo -e "\E[32m Done.... \E[0m \n"
		echo -e "Changing ownership, Please wait.....\n"
		chown -R www:www /usr/local/${instance}
		if [ $? -eq 0 ] ; then
		
			echo -e "\E[32m Done.....\n"
			echo "LIN UPDATE successful....."
			echo -e "Please validate and start the instance....\E[0m"
		        log $action $instance "--> Success"
			exit
	
		else
		
			echo -e "\E[31m Unable to Change the ownership of /usr/local/${instance} to www:www , Please check and do it manualy..."
			echo -e "\E[32m once you changed the ownership, LIN UPDATE will be completed... \E[0m"
			log $action $service "--> Partially Failed --> Need to change the ownership of the instance dir to comeplete the update"
			exit

		fi


	else

		echo -e "\E[31m Jar command Failed...."
		echo -e "\E[31m Please make sure /usr/local/java/bin/jar is available , if not create a simbolic link and try again...."
		echo -e "\E[31m if the file/command is already there, please refer the above jar command error and act accordingly...."
		echo -e "\E[31m Terminating the script, Please revert the backup, if needed. Backup detail is above.....\E[0m \n"
		log $action $service "--> Failed --> Changes Happen --> Needs to revert --> Backup is ${backup_dir}/${instance}_bkp_${dtf}.tgz"
		exit

	fi
	

else
	echo -e "\E[31m Something went wrong while removing old files, Please refer the above rm command error and act accordingly...."
	log $action $service "--> Failed --> Changes Happen --> Needs to revert --> Backup is ${backup_dir}/${instance}_bkp_${dtf}.tgz"
	exit
fi

else

	echo -e "\E[31m Unable to get in to the instance's lin directory ( 'cd /usr/local/${instance}/webapps/lin' --> failed ), Please Check..."
	echo "NO CHNAGES done so far to revert..."
	log $action $service "--> Failed --> No Changes Happen"
	exit
fi



}





log $action $service "--> Trying"
GetBuildInfo
Download
Backup
UpdateLin
}






if [ -z "$1" ] ; then

	type=manual
	PreCheck
else
	if [ ! -z "$2" ] ; then
		action=`echo $1 | tr 'A-Z' 'a-z'`
		service=`echo $2 | tr 'A-Z' 'a-z'`

		if [ "$action" == "status" ] || [ "$action" == "stop" ] || [ "$action" == "start" ] || [ "$action" == "restart" ] || [ "$action" == "linupdate" ] ; then
		
			if [ -f /etc/init.d/${service} ] ; then
				export $action
				export $service
				type=auto
				PreCheck
			else

				echo "Invalid service/input...."
				exit
			fi

		else
		
			echo "invalid action/input detected..."
			exit

		fi

	else
		echo "insufficient input detected"
		echo "if you are running this script by giving input parameters, please use below format"
		echo "./menu.sh <stop/start/restart/linupdate> <apache/tomcat/keepalive/tomcat_test/...>"
		exit
	fi

fi

