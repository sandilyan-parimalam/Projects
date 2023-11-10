#!/bin/bash
#Sandy, HSG
#this script will do auto-restart the instance based on the inputs.
#Syntax: ./CommonAutoRestart.sh Project_Level_Type_NodeN_InstanceName_restart autorestart NotStartedBundleBountToIgnore
#Example: ./CommonAutoRestart.sh RetailIHUB_uat_ihub_Node1-ihub_restart autorestart 1
#
RestartScript="/opt/scripts/tpp_portal_scripts/bin/CommandExecuter.sh"
Today=`date +%F`
EMailTO="sandilyan.parimalam@mytestorg.com"

function PreCheck() {


if [ ! -f "${RestartScript}" ] ; then

                echo "ERR: Unable to find the Restart Script, Please check as this will affect all the autorestarts"
                exit
fi


}


function AutoRestartFailed() {
cat /tmp/autorestart_${Random}.txt | mutt -e "set content_type=text/html" -s "Critical - Auto Restart FAILED for ${Project}-${Level}-${Type}-${instance} on ${Today}" ${EMailTO}
rm -f /tmp/autorestart_${Random}.txt
exit

}



function AutoRestartSuccess() {
cat /tmp/autorestart_${Random}.txt | mutt -e "set content_type=text/html" -s "Auto Restart Completed successfully for ${Project}-${Level}-${Type}-${Instance} on ${Today}" ${EMailTO}
rm -f /tmp/autorestart_${Random}.txt
exit

}

function AutoRestart() {

        Project=`echo ${1} | cut -d "_" -f1 | tr A-Z a-z`
        Level=`echo ${1} | cut -d "_" -f2 | tr A-Z a-z`
        Type=`echo ${1} | cut -d "_" -f3 | tr A-Z a-z`
        Instance=`echo ${1} | cut -d "_" -f4 `

        IgnoreBundleCount=`echo "$@" | rev | cut -d " " -f1 | rev`
        Status="Failed"
        ExecutionOP=`${RestartScript} ${@}`
        FailedBundleCount=`echo "${ExecutionOP}" | grep "FAILED" | awk '{print $3}'`
        NotStartedBundleCount=`echo "${ExecutionOP}" | grep "NOT STARTED" | awk '{print $4}'`
        Random=`date +%F_%H-%M-%S`
        echo "<pre>${ExecutionOP}" | tee -a /tmp/autorestart_${Random}.txt

        if [ ! -z "{FailedBundleCount}" ] && [[ $FailedBundleCount = *[[:digit:]]* ]]; then
                if [ ${FailedBundleCount} -gt 0 ] ; then

                        AutoRestartFailed
                fi
        else
                AutoRestartFailed

        fi

        if [ ! -z "${IgnoreBundleCount}" ] && [[ ${IgnoreBundleCount} = *[[:digit:]]* ]]; then

                 if [ ${IgnoreBundleCount} -gt 0 ] ; then

                        if [ "${IgnoreBundleCount}" == "${NotStartedBundleCount}" ] ; then
                                AutoRestartSuccess
                        else
                                AutoRestartFailed

                        fi
        fi
        elif [ ${NotStartedBundleCount} -gt 0 ] ; then
                AutoRestartFailed
        elif [ ${NotStartedBundleCount} -eq 0 ] ; then
                AutoRestartSuccess
        else
                echo "No Valid Ignore Bundle count detected - skipping the check"
                AutoRestartFailed
        fi

}




PreCheck
AutoRestart $@

