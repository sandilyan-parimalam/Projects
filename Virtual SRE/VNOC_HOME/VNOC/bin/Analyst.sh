#!/bin/bash
#Author:sandilyan.parimalam@mytestorg.com
#From:HSG@mytestorg.com
#Description:This is an anlyst which willl take inputs and work on that
#Syntax
#./Analyst.sh <IP> <Script>


function LoadLibrary() {
if [ -f "${HOME}/VNOC/bin/ShellFunctionsLibrary.sh" ] ; then

	. ${HOME}/VNOC/bin/ShellFunctionsLibrary.sh

else

        echo "Error Occurred"
	echo "ERR Info: Unable to locate '${HOME}'/VNOC/bin/ShellFunctionsLibrary.sh"
        echo "ERR Info: Parrent Script:${ParrentScript}"
        echo "ERR Info: Terminating Script Execution"
        exit


fi
}


function GatherInputs() {

	function AutoInput() {


echo "test"

	}




	function ManualInput() {

		read -p "Enter the server IP: " ServerIP

			CheckVariable ServerIP=${ServerIP}
                        CheckHostAvailability ${ServerIP}
			CheckHostLogin ${ServerIP}
                read -p "Enter the Script File with location: " Script
			CheckVariable Script=${Script}
#			CheckRemoteScript ${ServerIP} ${Script}
#		
                read -p "Enter the script arguments: " Args
                        CheckVariable Args=${Args}
			echo "${Args}"

	}

if [ -z "${1}" ] ; then
	ManualInput
else
	AutoInput
fi

}





LoadLibrary
GatherInputs
LoadConfig
