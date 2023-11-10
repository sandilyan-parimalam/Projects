#!/bin/bash
#Sandy
#this will execute the command from the LX portal
base_dir=/opt/scripts/tpp_portal_scripts/bin
NOW=`date +%F"-"%T`

Project=`echo ${1} | cut -d "_" -f1 | tr A-Z a-z`
Level=`echo ${1} | cut -d "_" -f2 | tr A-Z a-z`
Type=`echo ${1} | cut -d "_" -f3 | tr A-Z a-z`
Instance=`echo ${1} | cut -d "_" -f5 `




if [ "${Project}" ] && [ "${Level}" ]&& [ "${Type}" ] && [ "${Instance}" ]; then
	if [ ! -f "${base_dir}/TPPPortal.conf" ] ; then echo "${base_dir}/TPPPortal.conf missing..." ;fi

	if [ "${Instance}" == "all" ] ; then
		node_count=`grep -i "${Project}_${Level}_${Type}_node_count" ${base_dir}/TPPPortal.conf | cut -d "=" -f2`
		for ((i=1;i<=node_count;i++))
                do
		Instance=`grep -i "${Project}_${Level}_${Type}_node${i}_instance_name" ${base_dir}/TPPPortal.conf | cut -d "=" -f2`
	        Node_No="node${i}"
                Instance=`echo ${Instance} | cut -d "_" -f2`
                ServerIP=`grep -i "${Project}_${Level}_${Type}_${Node_No}_ip" ${base_dir}/TPPPortal.conf | cut -d "=" -f2`
                Script=`grep -i "${Project}_${Level}_${Type}_${Node_No}_startup_script" ${base_dir}/TPPPortal.conf | cut -d "=" -f2`
                Action=`echo ${1} | cut -d "_" -f5 | tr A-Z a-z`
                if [ ${Node_No} ] ; then

        	        echo -e "\n----------------------------------- Processing on ${Type} Node${i} ${Instance} (${ServerIP})------------------------------------------------------"
	
                        if [ "${Type}" == jboss ] ; then

                                if [ "${Action}" == "deploy" ] ; then

                                        FTPPath="${3}"
                                        FileName="${4}"
                                        ssh root@${ServerIP} "echo -e '${FTPPath}\n${FileName}\n'|/opt/jbossAS/scripts/menu.sh ${Instance} deploy ${FTPPath} ${FileName}"
                                elif [ "${Action}" == "apply" ] ; then
                                        FTPPath="${3}"
                                        FileName="${4}"
                                        ssh root@${ServerIP} "echo -e '${FTPPath}\n${FileName}\n'|/opt/jbossAS/scripts/menu.sh ${Instance} apply ${FTPPath} ${FileName}"

                                else

                                        echo "Please wait while ${Action}ing the service"
                                        ssh root@${ServerIP} "${Script} ${Action}"
                                fi
                        else
                                Script=`grep -i "${Project}_${Level}_${Type}_${Node_No}_deploy_script" ${base_dir}/TPPPortal.conf | cut -d "=" -f2`
                                Action=`echo ${Action}|sed 's#check#bundle_status#g'`
                                if [ "${Action}" == "start" ] || [ "${Action}" == "restart" ]; then

                                        ssh root@${ServerIP} "${Script} ${Instance} redeploy"


                                elif [ "${Action}" == "deploy" ] ; then

                                        FTPPath="${3}"
                                        FileName="${4}"
                                                echo "Deployment Initiated..."
                                                ssh root@${ServerIP} "${Script} ${Instance} ${Action} ${FTPPath} ${FileName}"

                                elif [ "${Action}" == "apply" ] ; then
                                        FTPPath="${3}"
                                        FileName="${4}"
                                        ScriptPath=`echo $Script | rev | cut -d "/" -f2- | rev`
                                        Instance=`echo ${1} | cut -d "_" -f5 `


                                        echo "Patching Initiated..."
                                        echo $Instance
                                        ssh root@${ServerIP} "echo -e '${FTPPath}\n${FileName}\n'|${ScriptPath}/apply_patch.sh ${Instance}"


                                else
                                        ssh root@${ServerIP} "${Script} ${Instance} ${Action}"

                                fi


                        fi


                else

                        echo "Node Number is Missing"
                        exit
                fi






		done

		exit

	else
                Instance=`echo ${1} | cut -d "_" -f5`
		Node_No=`echo ${1} | cut -d "_" -f4`
		ServerIP=`grep -i "${Project}_${Level}_${Type}_${Node_No}_ip" ${base_dir}/TPPPortal.conf | cut -d "=" -f2`
		Script=`grep -i "${Project}_${Level}_${Type}_${Node_No}_startup_script" ${base_dir}/TPPPortal.conf | cut -d "=" -f2`
		Action=`echo ${1} | cut -d "_" -f6 | tr A-Z a-z`
		if [ ${Node_No} ] ; then

	        	if [ "${Type}" == jboss ] ; then

				if [ "${Action}" == "deploy" ] ; then

                                        FTPPath="${3}"
                                        FileName="${4}"
                                        echo "Deployment Initiated..."
                                        ssh root@${ServerIP} "echo -e '${FTPPath}\n${FileName}\n'|/opt/jbossAS/scripts/jboss_deploybuild.sh ${Instance}"
				elif [ "${Action}" == "apply" ] ; then
                                        FTPPath="${3}"
                                        FileName="${4}"
                                        echo "Patching Initiated..."
                                        ssh root@${ServerIP} "echo -e '${FTPPath}\n${FileName}\n'|/opt/jbossAS/scripts/apply_patch.sh ${Instance}"
				

				else

					echo "Please wait while ${Action}ing the service"
					ssh root@${ServerIP} "${Script} ${Action}"
				fi
			else
                                Script=`grep -i "${Project}_${Level}_${Type}_${Node_No}_deploy_script" ${base_dir}/TPPPortal.conf | cut -d "=" -f2`
				Action=`echo ${Action}|sed 's#check#bundle_status#g'`
				if [ "${Action}" == "start" ] || [ "${Action}" == "restart" ]; then
				
                                	ssh root@${ServerIP} "${Script} ${Instance} redeploy"


				elif [ "${Action}" == "deploy" ] ; then

					FTPPath="${3}"
					FileName="${4}"
						echo "Deployment Initiated..."
						ssh root@${ServerIP} "${Script} ${Instance} ${Action} ${FTPPath} ${FileName}"

                                elif [ "${Action}" == "apply" ] ; then
                                        FTPPath="${3}"
                                        FileName="${4}"
					ScriptPath=`echo $Script | rev | cut -d "/" -f2- | rev`
					Instance=`echo ${1} | cut -d "_" -f5 `


                                        echo "Patching Initiated..."
					echo $Instance
                                        ssh root@${ServerIP} "echo -e '${FTPPath}\n${FileName}\n'|${ScriptPath}/apply_patch.sh ${Instance}"
			
			
				else
			                ssh root@${ServerIP} "${Script} ${Instance} ${Action}"
				
				fi
				

			fi


		else

			echo "Node Number is Missing"
			exit
		fi

	fi



else
        echo "Syntax error"
        echo "usage: ./script <Project>_<Level>_<Type>_<Instance>"
        echo "Example: ./CommandExecuter.sh Metlife_uat_jboss_All"
        exit
fi

