#!/bin/bash
#

cat <<ENDINFO

mytestorg - HSG  T O O L S
(c) 2013-2020 mytestorg, Inc.

ENDINFO

echo "==============="
echo "LIST OF OPTIONS"
echo "==============="
echo "1) Deploy IHUB build"
echo "2) Quit"
echo 
echo -n  'Select an option and press Enter: '
read i
   case $i in
      1) /opt/tppihub/script/ihub_deploy.sh;;
      2) exit 1;;
        *) echo illegal choice;;
   esac
exit 0
#end script
