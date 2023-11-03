#!/bin/bash
#
cat <<ENDINFO

mytestorg - HSG  T O O L S

JBOSS AS Maintenance Toolset
(c) 2013-2020 mytestorg, Inc.

This script list out the options for Start, Stop and Restart JBOSS AS instance.

It does the following:
1) List the JBOSS instances.
2) List the options for JBOSS Stop, Start and Restart.

ENDINFO


echo "==============="
echo "LIST OF OPTIONS"
echo "==============="
echo "1) Stop,Start and Restart TPP instance"
echo "2) Deploy TPP build"
echo "3) Apply TPP patch"
echo "4) Reverse TPP patch"
echo "5) Log Upload TPP"
echo "6) Quit"
echo 
echo -n  'Select an option and press Enter: '
read i
   case $i in
      1) /opt/jbossAS/scripts/tpp_app_maintenance.sh;;
      2) /opt/jbossAS/scripts/tpp_deploybuild.sh;;
      3) /opt/jbossAS/scripts/apply_patch.sh;;
      4) /opt/jbossAS/scripts/tpp_app_reversepatch.sh;;
      5) /opt/jbossAS/scripts/log-upload.sh;;
      6) exit 1;;
        *) echo illegal choice;;
   esac
exit 0
#end script
