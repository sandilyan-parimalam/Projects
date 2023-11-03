#!/bin/bash
#Vinothkanann Ramamurthi
#TPP Maintenance Script - H S G
#mytestorg Inc

cat <<ENDINFO

mytestorg - HSG  T O O L S

JBOSS AS Maintenance Toolset
(c) 2013-2020 mytestorg, Inc.

This script list out the options for Start, Stop and Restart JBOSS AS instance.

It does the following:
1) List the JBOSS instances.
2) List the options for JBOSS Stop, Start and Restart.

ENDINFO

instance=$1
if [ -z "$instance" ]; then
        COLUMNS=1
        PS3='Input a number: '
        echo
        echo Choose which JBOSS AS instance for maintenance:
        select instance in $(ls /etc/init.d/ | grep jboss*); do
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
echo "1) Restart $instance"
echo "2) Quit"
echo 
echo -n  'Select an option and press Enter: '
read i
   case $i in
      1) /etc/init.d/$instance restart;sleep 20s;ssh 10.20.14.22 /etc/init.d/$instance restart;;
      2) exit 1;;
        *) echo illegal choice;;
   esac
exit 0
#end script
