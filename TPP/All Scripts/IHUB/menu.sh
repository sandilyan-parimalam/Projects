#!/bin/bash
#

echo "

Welcome to IHUB Maintanence Script"

echo "==============="
echo "LIST OF OPTIONS"
echo "==============="
echo "1) Stop IHUB instance"
echo "2) Start/Restart IHUB instance (redeploy)"
echo "3) Apply Patch File"
echo "4) Deploy Build"
echo "5) Check Bundle Status"
echo "6) Quit"
echo
echo -n  'Select an option and press Enter: '
read i
   case $i in
      1) /opt/tppihub/scripts/deploy_script/ihub_deploy.sh stop;;
      2) /opt/tppihub/scripts/deploy_script/ihub_deploy.sh redeploy;;
      3) /opt/tppihub/scripts/deploy_script/apply_patch.sh;;
      4) /opt/tppihub/scripts/deploy_script/ihub_deploy.sh deploy;;
      5) /opt/tppihub/scripts/deploy_script/ihub_deploy.sh bundle_status;;
      6) exit 1;;
        *) echo illegal choice;;
   esac
exit 0
#end script

