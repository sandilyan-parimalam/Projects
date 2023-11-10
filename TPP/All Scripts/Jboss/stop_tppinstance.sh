#!/bin/bash
#Jboss Maintenance Script
#Author:Vinothkannan Ramamurthi
#mytestorg Inc.,
if [ `whoami` == "jboss" ];
then
cat <<ENDINFO


JBOSS APP Server - Stop Script

This script list out the options for Stop JBOSS JVM instance.

It does the following:
1) List the JBOSS JVM instances.
2) List the options to Stop JVM.

ENDINFO

instance=$1
if [ -z "$instance" ]; then
        COLUMNS=1
        PS3='Input a number: '
        echo
        echo Choose which JBOSS JVM instance for maintenance:
        select instance in $(ls /opt/jbossAS/tppinstance | grep "tpp*"); do
                if [ $instance ]; then
                        break;
                else
                        echo Invalid selection.
                fi
        done
fi
echo "==============="
echo "LIST OF OPTIONS"
echo "==============="
echo "1) Stop $instance"
echo "2) Quit"
echo 
echo -n  'Select an option and press Enter: '
read i
   case $i in
      1)ps -ef | grep "$instance" | awk '{print $2}' | xargs kill;;
      2) exit 1;;
        *) echo illegal choice;;
   esac
exit 0
else
echo "Stop TPP instances using jboss user"
fi
#end script
