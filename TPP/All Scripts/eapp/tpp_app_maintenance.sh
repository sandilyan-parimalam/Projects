#!/bin/bash
#Vinothkanann Ramamurthi
#TPP Maintenance Script - H S G
#mytestorg Inc


instance=$1
if [ -z "$instance" ]; then
        COLUMNS=1
        PS3='Input a number: '
        echo
        echo Choose which JBOSS AS instance for maintenance:
        select instance in $(ls /etc/init.d/ | grep jboss* | egrep -iv 'bk|old|not|use|tpp' ); do
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
echo "2) Start $instance"
echo "3) Restart $instance"
echo "4) Quit"
echo 
echo -n  'Select an option and press Enter: '
read i
   case $i in
      1) /etc/init.d/$instance stop;;
      2) /etc/init.d/$instance start;;
      3) /etc/init.d/$instance restart;;
      4) exit 1;;
        *) echo illegal choice;;
   esac
exit 0
#end script
