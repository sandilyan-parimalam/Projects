#!/bin/bash
#Desc:mytestorg Health Maintenance script
#Author:Sandy

basedir="/opt/scripts/maintenance_scripts"

function PreCheck() {
if [ ! -z "$basedir" ] ; then

        if [ -d "$basedir/bin" ] ; then

                if [ ! -d "$basedir/logs" ] ; then
                        mkdir $basedir/logs
                fi

                        GetInfo

        else
                echo "$basedir/bin directory is missing, Please copy the directory and files then retry.."
                exit
        fi
else

        echo "Set base dir properly and run me again"
        exit

fi
}


function GetInfo() {


                                                                                                #select action
echo "
        Welcome to the mytestorg Health Maintenance Script
        ----------------------------------------------
        ---------------------------------------------

Please select the action
==================
1) Check a Service
2) Stop a Service
3) Start a Service
4) Restart a Service
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

        else
                echo "Invalid Option, Please try again"
                exit
        fi
else
        echo "Empty Input, please try again"
        exit
fi

echo "
Please select the client
===================
"
PS3='Enter the Client number: '
select client in $( vzlist | grep running | grep -v train | rev | acol 1 | rev | cut -d "." -f1 | sed 's#www##g' ); do

if [ ! -z $client ] ; then

	cid=`vzlist | grep $client | grep -v grep | head -1 |acol 1`
	if [ ! -z $cid ] ; then
		break
	else
		echo "Unable to find the container ID with the hostname of $client ...,please check is there any duplication.."
		exit
	fi
else
        echo "Invalid input, Please try again.."
        exit
fi
done


echo "
Select one of the available service for $client
===============================================
"
PS3='Enter the sevice number: '
select service in  $(vzctl exec $cid "ls /etc/init.d/ | egrep  '^apache|lin|^keepalive*' | egrep -v 'old|don|not|bkp|backup|z'| sed 's#test_lin#tomcat_test#g' | sort"); do
if [ ! -z $service ] ; then

	ExecuteCommand
        break

else
        echo "Invalid input, Please try again.."
        exit
fi
done



}

function ExecuteCommand() {

function status() {

        if [ $service == apache ] ; then
		echo "Checking Apache status......"
		pid=`vzctl exec $cid 'netstat -anp | egrep "LISTEN" | grep httpd | rev | acol 1 | rev | cut -d "/" -f1 | head -1'`
		is_listen=`vzctl exec $cid 'netstat -anp | egrep "LISTEN" | grep httpd | acol 4 | sed 's#:##g''`
		if [ ! -z "$is_listen" ] ; then
			echo -e "Apache is \E[32m[ UP ]\E[0m for $client with the PID of $pid"
			echo -e "Apache is \E[32m[ LISTENING ]\E[0m for the below ports"
			echo "$is_listen"
		else
			echo -e "Apache is \E[31m[ DOWN ]\E[0m or \E[31m[ NOT LISTENING ]\E[0m"
		fi

                echo -e "\nChecking Tomcat status......"
                pid=`vzctl exec $cid 'ps -aef | grep /tomcat/ | grep -v grep | acol 2'`
                if [ ! -z "$pid" ] ; then
                        echo -e "Tomcat is \E[32m[ UP ]\E[0m for $client with the PID of $pid"
                        exit
                else
                        echo -e "Tomcat is \E[31m[ DOWN ]\E[0m for $client"
                        exit
                fi

	else
		pid=`vzctl exec $cid 'ps -aef' | grep "/${service}/" | grep -v grep | acol 2`
                if [ ! -z "$pid" ] ; then
			echo -e "$service is \E[32m[ UP ]\E[0m for $client with the PID of $pid"
			exit
		else

                        echo -e "$service is \E[31m[ DOWN ]\E[0m for $client"
			exit
			 
		fi


         fi


}

function stop() {
        echo "Stopping $service of $client ..."
        log $when $me $from $action $service $client
        sleep 2
        vzctl exec $cid /etc/init.d/$service_name stop
        sleep 3
        echo -e "\nService Stopped , Please check the status and confirm.."
        exit


}

function start() {

        echo "Starting $service of $client ..."
        log $when $me $from $action $service $client
#vzctl exec $cid bash -c "'/etc/init.d/$service_name start'"


vzctl enter $cid << EOF
/bin/ls
EOF
        sleep 3
        echo -e "\nService Started , Please check the status and confirm.."
        exit


}
function restart() {


	        log $when $me $from $action $service $client
                echo "Stopping $service of $client ..."
	        vzctl exec $cid /etc/init.d/$service_name stop
                sleep 5
                is_dead=`status | grep UP`
                if [ ! -z "$is_dead" ] ; then kill -9 $pid ; echo "process killed" ; fi
                echo "Starting $service of $client ..."
                vzctl exec $cid /bin/bash /etc/init.d/$service_name start
                sleep 3
                echo "$service of $client has been started, please check status and confirm...."
                exit


}

me=`who am i | awk '{print $1}'`
from=`who am i | awk '{print $5}' | cut -c2- | rev | cut -c2- | rev`
when=`date +%F' '%T`

        #calling function below
service_name=`echo $service | sed 's#tomcat_test#test_lin#g'`
$action
}

function log() {

echo "`hostname` $@" >> $basedir/logs/activity.log

}








PreCheck
