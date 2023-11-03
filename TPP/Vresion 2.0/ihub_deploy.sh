#!/bin/bash
						#################################################################
						#	Author		:	P.sandilyan,HSG			#
						#	Description	:	Script for I-HUB deployment	#
						#################################################################


# configuration file location
base_dir=`pwd`

# conf check
if [ -f $base_dir/ihub_deploy.conf ]
then
source $base_dir/ihub_deploy.conf
else
echo "configuration file is missing, please check,terminating the script..."
exit
fi


#	Handy Varriables

declare -a deploy_files
build_jar_count=0


function pre_check() {

if [ "$env" != "TPP" ] && [ "$env" != "IHUB" ] ; then echo "ENVIRONMENT NOT SET PROPERLY ON CONF FILE, PLASE CHECK AND RUN ME AGAIN.....TERMINATING THE SCRI
PT" | tee -a $log ; fi

}

#	Function declarations

function download_build() {

attempt=0
echo
while read -p "ENTER THE FTP PATH OF THE BUILD " a; 
do
        if [[ -z "${a}" ]]
        then
        {
                if [ $attempt -gt 2 ]
                then
                echo -e  "\nYOU HAVE EXCEEDED MAXIMUM ATTEMPTS, PLEASE REFER THE SCRIPT DOCUMENTATION :-() \n"
                exit
                else
                attempt=$((attempt+1))
                echo -e "\nATTEMPT $attempt of 3\n"
		echo -e "\n		EMPTY INPUT :-() \n"
		continue
                fi
        }
        else
        {
                attempt=0
		
		tmp1=`echo $a | rev | cut -c1`		
		if [ "$tmp1" !=  "/" ] ; then a=`echo $a | rev | sed 's#^#/#' | rev` ; fi	
	
		echo
                while read -p "ENTER THE ZIP FILE NAME TO BE DEPLOYED:" b;
                do
                        if [[ -z "${b}" ]]
                        then
                        {
                                if [ $attempt -gt 2 ]
                                then
                                echo -e "\nYOU HAVE EXCEEDED MAXIMUM ATTEMPTS PLEASE REFER THE SCRIPT DOCUMENTATION :-() \n"
                                exit
                                else
                                attempt=$((attempt+1))
                                echo -e "\nATTEMPT $attempt of 3\n"
                                echo -e "\n		EMPTY INPUT :-() \n"
				continue
                                fi
                        }
                        else
                        {

				if [ ! -d $WORK_DIR ] ; then
				{
					echo -e "\nCREATING WORK DIR\n" 
					mkdir $WORK_DIR
				}
				else
				{
				echo
				echo -e "\nCLEARING WORK DIR"
				rm -rf $WORK_DIR
				mkdir $WORK_DIR
				}
				fi
				if [ ! -d $LOG_DIR ] ; then
				mkdir $LOG_DIR
				touch $log
				else
				touch $log
				fi
				if [ -d $BLD_DIR ]
				then
				rm -rf $BLD_DIR
				mkdir $BLD_DIR
				echo -e  "\nCREATING BUILD DIRECTORY\n" | tee -a $log
				else
				mkdir $BLD_DIR
                                echo -e  "CREATING BUILD DIRECTORY\n" | tee -a $log
				fi
				cd "$BLD_DIR"
				echo -e "DOWNLOADING BUILD FROM FTP\n" | tee -a $log
				ftp -pinv $FTPSRV <<End-Of-Session > ${ftp_log}
				user $UNAME $PASSWORD
				bin
				cd $a
				size $b
				get $b
				bye
End-Of-Session
				ssize=`cat ${ftp_log} | grep 213 | cut -d " " -f2`
				dsize=`cat ${ftp_log} | grep "bytes received" | cut -d " " -f1`
				cat ${ftp_log} | grep "${ftp_size_err}"
				if [ $? -ne 0 ]
				then
				if [ "$ssize" == "$dsize" ] ; then
				echo -e  "BUILD DOWNLOADED\n" | tee -a $log
				echo -e "EXTRACTING THE BUILD\n" | tee -a $log
				unzip $b
					if [ $? -eq 0 ] ; then
					echo -e "\nEXTRACTION COMPLETE\n" | tee -a $log
					rm "$BLD_DIR$b"
					else
					echo -e "DOWNLOADED ZIP FILE CURREPTED OR INVALID, PLEASE CHECK THE ($b)ZIP FILE \n" | tee -a $log
					exit
					fi
				else	
				echo -e "DOWNLOAD INTERUPTED, PLEAE RETRY\n" | tee -a $log
				exit
				fi
				else
				echo -e "GIVEN FILE NOT FOUND ON FTP, PLEASE VERIFY THE PATH($a$b) YOU GAVE\n" | tee -a $log
				exit
				fi
                                break

                        }
                        fi
                break
                done



        }
        fi
break
done



}



function stop_karaf () {

pid=`ps -ef | grep karaf | grep -v grep | awk '{print $2}'`
echo -e "\nSTOPPING KARAF SERVICE\n" | tee -a $log
if [ -z "$pid" ]
then
	echo -e "\nKARAF SERVICE  NOT RUNNING\n" | tee -a $log
else
	/etc/init.d/karaf-service stop
	pid=`ps -ef | grep karaf | grep -v grep | awk '{print $2}'`
		if [ -z $pid ]
		then
			echo -e "KARAF SERVICE STOPPED\n" | tee -a $log
		else
			for i in `echo $pid`
			do
			kill -9 $i
			done
			pid=`ps -ef | grep karaf | grep -v grep | awk '{print $2}'`
				if [ -z $pid ]
				then
					echo -e "KARAF SERVICE STOPPED\n" | tee -a $log
				else
					echo -e "THERE IS PROBLEM WITH STOPING KARAF SERVICE,PlEASE CHECK\n" | tee -a $log
				fi
		fi
fi

}




function start_karaf () {
pid=`ps -ef | grep karaf | grep -v grep | awk '{print $2}'`
echo -e "\nSTARTING KARAF SERVICE\n" | tee -a $log
if [ -z "$pid" ]
then
        /etc/init.d/karaf-service start
        pid=`ps -ef | grep karaf | grep -v grep | awk '{print $2}'`
                if [ -z "$pid" ]
                then
                        echo -e "UNABLE TO START KARAF SERVICE, PLEASE CHECK\n" | tee -a $log
                        exit
                else
                        echo -e "KARAF SERVICE STARTED\n" | tee -a $log
                fi

else
	echo -e "KARAF SERVICE IS ALREADY RUNNING,PLEASE VERIFY\n" | tee -a $log
	
fi


}







function prepare_build() {


# storing jar files
cd $BLD_DIR
tmp_jar_files=$(ls *.jar)
build_jar_count=0
declare -a build_jar_file
for i in $tmp_jar_files
do
build_jar_files[build_jar_count++]=$i
done
echo
echo "$build_jar_count jar files in the build"
echo ${build_jar_files[*]}
echo



# Replacing new jar bundles with old

cd $BLD_DIR

echo -e "COMPARIING NEW BUILD WITH CURRENT BUILD \n" | tee -a $log
new_files=`ls *.jar | sed 's# #\n#g'`
bld_count=`ls *.jar | sed 's# #\n#g' | wc -w`
confirm_value=0
for i in $new_files
do

fndvar=`echo $i | rev | cut -d "-" -f2 | rev`
cd $DEPLOY_WORK_DIR
old_file=`find -name $fndvar-* | sed 's#./##g'`

if [ ! -z "$old_file" ] ; then

        if [ $i != $old_file ] ; then

                echo "NEW VERSION OF A BUNDLE FOUND IN BUILD" | tee -a $log
                echo "CURRENT VERSION="$old_file | tee -a $log
                echo -e "NEW VERSION="$i "\n" | tee -a $log
                rm $DEPLOY_WORK_DIR$old_file
                cp $BLD_DIR$i $DEPLOY_WORK_DIR
				if [ $? -eq 0 ] ; then
				{
				        confirm_value=$((confirm_value+1))
				}
				fi

        else

                echo "SAME VERSION OF BUNDLE IS ABOUT TO DEPLOY" | tee -a $log
                echo -e "BUNDLE NAME="$i "\n" | tee -a $log
                rm $DEPLOY_WORK_DIR$old_file
                cp $BLD_DIR$i $DEPLOY_WORK_DIR
			if [ $? -eq 0 ] ; then
			{
			        confirm_value=$((confirm_value+1))
			}
			fi


        fi

else

echo "SEEMS LIKE NEW BUNDLE IS ABOUT TO DEPLOY" | tee -a $log
echo -e "BUNDLE NAME IS="$i "\n" | tee -a $log
cp $BLD_DIR$i $DEPLOY_WORK_DIR
if [ $? -eq 0 ] ; then
{
        confirm_value=$((confirm_value+1))
}
fi

fi


done





if [ $confirm_value -eq $bld_count ] ; then
{
start_karaf

}
else
{

echo -e "\nThere is problem with mingiling new jar bundles with existing,may be by full  drivespace " | tee -a $log
echo -e "\njar files under $BLD_DIR are not replaced or placed with the files under $DEPLOY_WORK_DIR" | tee -a $log
echo -e "\n!!!!!!!!!!!!!!!!!!!!!!!!PLEASE REVERT THE DEPLOYMENT MANUALY, BACKUP OF DEPLOY DIR IS UNDER $BKP_DIR !!!!!!!!!!!!!!!!!!!!!!!!!!" | tee -a $log
exit
}
fi

}




function start_deploy() {

cd $DEPLOY_WORK_DIR


if [ $env -eq "TPP" ] ; then
service_bundle=`ls | sed 's# #\n#g' | grep 'tpp-services-'`
import_bundle=`ls | sed 's# #\n#g' | grep 'caseimport-'`
export_bundle=`ls | sed 's# #\n#g' | grep 'CaseExport'`

if [ -z $service_bundle ] ; then echo "SERVICE BUNDLE IS MISSING ON  CURRENT BUILD,THIS SCRIPT WILL NOT BE ABLE TO HANDLE THIS SCENARIO,PLEASE DO THE MANUAL DEPLOYMENT OR PLACE THE SERVICES BUNDLE ON NEW BUILD OR OLD BUILD THEN DEPLOY AGAIN" | tee -a $log ; exit ; fi

if [ -z $import_bundle ] ; then echo "CASE IMPORT BUNDLE IS MISSING ON  CURRENT BUILD,THIS SCRIPT WILL NOT BE ABLE TO HANDLE THIS SCENARIO,PLEASE DO THE MANUAL DEPLOYMENT OR PLACE THE SERVICES BUNDLE ON NEW BUILD OR OLD BUILD THEN DEPLOY AGAIN" | tee -a $log ; exit ; fi

if [ -z $export_bundle ] ; then echo "CASE EXPORT BUNDLE IS MISSING ON  CURRENT BUILD,THIS SCRIPT WILL NOT BE ABLE TO HANDLE THIS SCENARIO,PLEASE DO THE MANUAL DEPLOYMENT OR PLACE THE SERVICES BUNDLE ON NEW BUILD OR OLD BUILD THEN DEPLOY AGAIN" | tee -a $log ; exit ; fi


cp $service_bundle $DPLY_DIR
cp $import_bundle $DPLY_DIR

function tpp_special_step() {
stop_karaf
safevar="$DPLY_DIR*"
rm $safevar
start_karaf
wst=$(`echo "list" > list && sshpass -p "smx" ssh -t -t -o StrictHostKeyChecking=no -p 8101 smx@localhost < list >  /dev/null`)
sleep 10
wst=$(`echo "list" > list && sshpass -p "smx" ssh -t -t -o StrictHostKeyChecking=no -p 8101 smx@localhost < list >  /dev/null`)
sleep 10
}
tpp_special_step

echo -e "DEPLOYING BUNDLES.............\n" | tee -a $log
cp $service_bundle $DPLY_DIR
if [ $? -eq 0 ] ; then
        echo -e "SERVICE BUNDLE DEPLOYED SUCCESSFULLY,SLEEPING FOR 10 SECONDS........\n" | tee -a $log
	wst=$(`echo "list" > list && sshpass -p "smx" ssh -t -t -o StrictHostKeyChecking=no -p 8101 smx@localhost < list > /dev/null`)
        sleep 10
        cp $import_bundle $DPLY_DIR
                if [ $? -eq 0 ] ; then
                          echo -e "CASE IMPORT BUNDLE DEPLOYED SUCCESSFULLY,SLEEPING FOR 20 SECONDS.......\n" | tee -a $log
			  wst=$(`echo "list" > list && sshpass -p "smx" ssh -t -t -o StrictHostKeyChecking=no -p 8101 smx@localhost < list >  /dev/null`)
                          sleep 20
                          ls | sed 's# #\n#g' | grep -v "$service_bundle" | grep -v "$import_bundle" | grep -v "$export_bundle" | xargs -i cp {} $DPLY_DIR
                                if [ $? -eq 0 ] ; then
                                        echo -e "REST OF THE BUNDLES DEPLOYED SUCCESSFULLY , EXCEPT CASE IMPORT BUNDLE, SLEEPING FOR 40 SECONDS.......\n" | tee -a $log
					wst=$(`echo "list" > list && sshpass -p "smx" ssh -t -t -o StrictHostKeyChecking=no -p 8101 smx@localhost < list > /dev/null`)
                                        sleep 60
                                        cp $export_bundle $DPLY_DIR
                                                if [ $? -eq 0 ] ; then
                                                        echo -e "CASE EXPORT BUNDLE DEPLOYED SUCCESSFULLY........\n" | tee -a $log
							wst=$(`echo "list" > list && sshpass -p "smx" ssh -t -t -o StrictHostKeyChecking=no -p 8101 smx@localhost < list > /dev/null`)
							sleep 10
                                                else
                                                        echo "UNABLE TO DEPLOY CASE EXPORT BUNDLE, COPY COMMAND FILAED MAYBE BY FULL DRIVE SPACE,DROPING THE DEPLOYMENT,CHECK THE ISSUE AND COMEAGIN, IF YOU LIKE TO DO MANUAL DEPLOYMETN, BACKUP IS ALREADY IN PLACE......." | tee -a $log
                                                        exit
                                                fi
                                else
                                        echo "UNABLE TO DEPLOY REST OF THE BUNDLES, COPY COMMAND FILAED MAYBE BY FULL DRIVE SPACE,DROPING THE DEPLOYMENT,CHECK THE ISSUE AND COMEAGIN, IF YOU LIKE TO DO MANUAL DEPLOYMETN, BACKUP IS ALREADY IN PLACE......." | tee -a $log
                                        exit
                                fi
                else
                        echo "UNABLE TO DEPLOY IMPORT BUNDLE, COPY COMMAND FILAED MAYBE BY FULL DRIVE SPACE,DROPING THE DEPLOYMENT,CHECK THE ISSUE AND COMEAGIN, IF YOU LIKE TO DO MANUAL DEPLOYMETN, BACKUP IS ALREADY IN PLACE......." | tee -a $log
                        exit
                fi
else
echo "UNABLE TO DEPLOY SERVICE BUNDLE, COPY COMMAND FILAED MAYBE BY FULL DRIVE SPACE,DROPING THE DEPLOYMENT,CHECK THE ISSUE AND COMEAGIN, IF YOU LIKE TO DO MANUAL DEPLOYMETN, BACKUP IS ALREADY IN PLACE......." | tee -a $log
exit
fi

fi



# DEPLOYMENT STEPS FOR IHUB
if [ $env -eq "IHUB" ] ; then

docuSign_bundle=`ls | sed 's# #\n#g' | grep 'mytestorg-docuSign-'`
docuSignmsglogger_bundle=`ls | sed 's# #\n#g' | grep 'mytestorg-docuSignmsglogger-'`

if [ -z "$docuSign_bundle" ] ; then echo "DOCUSIGN BUNDLE IS MISSING ON  CURRENT BUILD,THIS SCRIPT WILL NOT BE ABLE TO HANDLE THIS SCENARIO,PLEASE DO THE MANUAL DEPLOYMENT OR PLACE THE SERVICES BUNDLE ON NEW BUILD OR OLD BUILD THEN DEPLOY AGAIN" | tee -a $log ; exit ; fi

if [ -z "$docuSignmsglogger_bundle" ] ; then echo "DOCUSIGNMSGLOGGER BUNDLE IS MISSING ON  CURRENT BUILD,THIS SCRIPT WILL NOT BE ABLE TO HANDLE THIS SCENARIO,PLEASE DO THE MANUAL DEPLOYMENT OR PLACE THE SERVICES BUNDLE ON NEW BUILD OR OLD BUILD THEN DEPLOY AGAIN" | tee -a $log ; exit ; fi


echo -e "DEPLOYING BUNDLES.............\n" | tee -a $log
cp $docuSign_bundle $DPLY_DIR
if [ $? -eq 0 ] ; then
        echo -e "DOCUSIGN BUNDLE DEPLOYED SUCCESSFULLY,SLEEPING FOR 10 SECONDS........\n" | tee -a $log
	wst=$(`echo "list" > list && sshpass -p "smx" ssh -t -t -o StrictHostKeyChecking=no -p 8101 smx@localhost < list > /dev/null`)
        sleep 10
        cp $docuSignmsglogger_bundle $DPLY_DIR
                if [ $? -eq 0 ] ; then
                          echo -e "DOCUSIGNMSGLOGGER BUNDLE DEPLOYED SUCCESSFULLY,SLEEPING FOR 20 SECONDS.......\n" | tee -a $log
                          wst=$(`echo "list" > list && sshpass -p "smx" ssh -t -t -o StrictHostKeyChecking=no -p 8101 smx@localhost < list > /dev/null`)
                          sleep 20
                          ls | sed 's# #\n#g' | grep -v "$docuSign_bundle" | grep -v "$docuSignmsglogger_bundle" | xargs -i cp {} $DPLY_DIR
                                if [ $? -eq 0 ] ; then
                                        echo -e "REST OF THE BUNDLES DEPLOYED SUCCESSFULLY , SLEEPING FOR 30 SECONDS.......\n" | tee -a $log
					wst=$(`echo "list" > list && sshpass -p "smx" ssh -t -t -o StrictHostKeyChecking=no -p 8101 smx@localhost < list > /dev/null`)
                                        sleep 30
                                else
                                        echo "UNABLE TO DEPLOY REST OF THE BUNDLES, COPY COMMAND FILAED MAYBE BY FULL DRIVE SPACE,DROPING THE DEPLOYMENT,CHECK THE ISSUE AND COMEAGIN, IF YOU LIKE TO DO MANUAL DEPLOYMETN, BACKUP IS ALREADY IN PLACE......." | tee -a $log
                                        exit
                                fi
                else
                        echo "UNABLE TO DEPLOY DOCUSIGNMSGLOGGER BUNDLE, COPY COMMAND FILAED MAYBE BY FULL DRIVE SPACE,DROPING THE DEPLOYMENT,CHECK THE ISSUE AND COMEAGIN, IF YOU LIKE TO DO MANUAL DEPLOYMETN, BACKUP IS ALREADY IN PLACE......." | tee -a $log
                        exit
                fi
else
echo "UNABLE TO DEPLOY DOCUSIGN BUNDLE, COPY COMMAND FILAED MAYBE BY FULL DRIVE SPACE,DROPING THE DEPLOYMENT,CHECK THE ISSUE AND COMEAGIN, IF YOU LIKE TO DO MANUAL DEPLOYMETN, BACKUP IS ALREADY IN PLACE......." | tee -a $log
exit
fi


fi
}



function backup_bundle() {
# BACKING UP THE EXISTING BUNDLES

if [ ! -d $DPLY_DIR ] 
then
{
	echo -e "\nDEPLOY DIR IS MISSING PLEASE VERIFY THE INSTANCE " | tee -a $log
	exit
}
fi

if [ ! -d $BKP_DIR ] ; then
mkdir $BKP_DIR
fi

echo -e "\nBACKING UP CURRENT BUNDLES" | tee -a $log
cp -r $DPLY_DIR $WORK_DIR
if [ $? -eq 0 ] ; then
{
	
	tar -czf "$BKP_DIR$BKP_FNAME.tar.gz" $DPLY_DIR.
	if [ $? -eq 0 ] ; then
	{

		safevar="$DPLY_DIR*"
		rm -rf $safevar
		echo -e "\nBACKUP COMPLETE" | tee -a $log
		
	}
	else
	{
        echo -e "\nBACKUP FAILED WHILE  TARRING " | tee -a $log
        echo -e "\nTERMINATING DEPLOYMENT TO PREVENT DATA LOSE" | tee -a $log
        exit

	}
	fi
}
else
{
	echo -e "\nBACKUP FAILED WHILE  COPYING TO THE WORK DIRECTORY" | tee -a $log
	echo -e "\nDISCK FULL MAY THE POSSIBLE REASONS, PLEASE CHECK" | tee -a $log
	echo -e "\nTERMINATING DEPLOYMENT TO PREVENT DATA LOSE" | tee -a $log
	exit

}
fi

# removing data dir
 if [ -d $DATA_DIR ] 
then
{
	echo -e "\nCLEARING DATA DIR" | tee -a $log
	rm -rf $DATA_DIR

}

else
{
	echo -e "\nDATA DIR ALREADY CLEARED" | tee -a $log
}

fi
			
}


function deploy_result() {
echo
BUNDLE_COUNT=`ls $DPLY_DIR | wc -w`
echo -e "\nCHECKING DEPLOYMENT RESULT" | tee -a $log
while echo "list" > list && sshpass -p "smx" ssh -t -t -o StrictHostKeyChecking=no -p 8101 smx@localhost < list | tail -$((BUNDLE_COUNT+1)) | sed  -e $((BUNDLE_COUNT+2))d > ${temp_log}
do
cat ${temp_log} | cut -d "[" -f5 |cut -d "]" -f1 | grep "Failed"
	if [ $? -eq 0 ] ; then
	echo -e "\nDEPLOYMENT FAILED,PLEASE SEE THE BELOW OUTPUT FOR MORE INFO" | tee -a $log
	break
	else
	cat ${temp_log} | cut -d "[" -f5 |cut -d "]" -f1 | grep " "
		if [ $? -eq 0 ];then
			for i in 30 1
			do
				if [ "$i" == "1" ]
				then
				echo -e "\nDEPLOYMENT FAILED. SOME OF THE BUNDLES STILL NOT STARTED, PLEASE VERIFY" | tee -a $log
				break 2
				else
				echo -e "\nWAITING FOR ONE MORE MINUTE, SINCE ALL BUNDLES ARE NOT YET STARTED " | tee -a $log
				sleep $i
				continue 1
				fi
			done

		else
			echo -e "\nDEPLOYMENT SUCCESSS, PLEASE REFER THE BELOW OUTPUT" | tee -a $log
			break
		fi
	fi
done
echo
echo -e "\n******************************************************************************************************" | tee -a $log
cat ${temp_log} | tee -a $log
echo -e "\n******************************************************************************************************" | tee -a $log
}


function redeploy() {
                                if [ ! -d $WORK_DIR ] ; then
                                {
                                        echo -e "\nCREATING WORK DIR\n"
                                        mkdir $WORK_DIR
                                }
                                else
                                {
                                echo
                                echo -e "\nCLEARING WORK DIR"
                                rm -rf $WORK_DIR
                                mkdir $WORK_DIR
                                }
                                fi
                                if [ ! -d $LOG_DIR ] ; then
                                mkdir $LOG_DIR
                                touch $log
                                else
                                touch $log
                                fi

pre_check
stop_karaf
backup_bundle
start_karaf
sleep 5
wst=$(`echo "list" > list && sshpass -p "smx" ssh -t -t -o StrictHostKeyChecking=no -p 8101 smx@localhost < list >  /dev/null`)
sleep 5
wst=$(`echo "list" > list && sshpass -p "smx" ssh -t -t -o StrictHostKeyChecking=no -p 8101 smx@localhost < list >  /dev/null`)
sleep 5
wst=$(`echo "list" > list && sshpass -p "smx" ssh -t -t -o StrictHostKeyChecking=no -p 8101 smx@localhost < list >  /dev/null`)
start_deploy
deploy_result
}



# checking for redeployment
if [ "$1" == "redeploy" ]
then
echo -e "\nSTARTING RE-DEPLOYMENT WITH EXISTING BUNDLES" | tee -a $log
redeploy
exit
fi



function get_conf_info() {
attempt=0
apply_cfg_files="no"
while read -p "DO YOU HAVE ANY CFG FILES TO APPLY...(yes/no)?:" opt1;
do
     	opt1=`echo $opt1 | tr A-Z a-z`
        if [[ -z "$opt1" ]] ; then

                if [ $attempt -gt 2 ] ; then

                        echo -e "\nYOU HAVE EXCEEDED MAXIMUM ATTEMPTS, PLEASE REFER THE SCRIPT DOCUMENTATION :-() \n"
                        exit
                else

                        attempt=$((attempt+1))
                        echo -e "\nATTEMPT $attempt of 3\n"
                        echo -e "\n             EMPTY INPUT :-() \n"
                        continue
                fi

        elif [[ $opt1 == yes ]] ; then
                cfgcount_attempt=0

                while read -p "OK...HOW MANY FILES..(ex:1)?:" cfgcount;
                do

                        if [[ -z "$cfgcount" ]] ; then

                                if [ "$cfgcount_attempt" -gt 2 ] ; then
                                        echo -e "\nYOU HAVE EXCEEDED MAXIMUM ATTEMPTS, PLEASE REFER THE SCRIPT DOCUMENTATION :-() \n"
                                        exit
                                else

                                        cfgcount_attempt=$((cfgcount_attempt+1))
                                        echo -e "\nATTEMPT $cfgcount_attempt of 3\n"
                                        echo -e "\n             EMPTY INPUT :-() \n"
                                        continue
                                fi
                        fi

                        if [[ "$cfgcount" != *[[:alpha:]]* ]] && [[ $cfgcount -ge 1 ]] ; then

                                        cfgpath_attempt=0
                                        echo "IF YOU PLANNING TO APPLY MORE CFG FILES, ALL SHOULD BE UNDER SAME PATH,IF NOT,PLEASE DO IT MANUALLY AND RUN ME AGAIN..."
                                        while read -p "PLEASE GIVE ME THE FTP PATH: " cfgftppath;
                                        do
                                                if [[ -z $cfgftppath ]] ; then

                                                        if [ "$cfgpath_attempt" -gt 2 ] ; then

                                                                echo -e "\nYOU HAVE EXCEEDED MAXIMUM ATTEMPTS, PLEASE REFER THE SCRIPT DOCUMENTATION :-() \n"
                                                                exit
                                                        else

                                                                cfgpath_attempt=$((cfgpath_attempt+1))
                                                                echo -e "\nATTEMPT $cfgpath_attempt of 3\n"
                                                                echo -e "\n             EMPTY INPUT :-() \n"
                                                                continue
                                                        fi
                                                else

                                                        echo "ASSUMING GIVEN PATH IS OK, IF NOT YOU WILL GET ERROR ON FURTHER EXECUTION..."
                                                        break
                                                fi

                                        done

                                        echo "" > $cfgfiles
                                        for (( i=1; i<=$cfgcount; i++ ))
                                        do
                                                cfgfile_attempt=0
                                                while read -p "PLEASE GIVE ME FILENAME( $i ): " cfgfile;
                                                do

                                                        if [[ -z $cfgfile ]] ; then

                                                        if [ "$cfgfile_attempt" -gt 2 ] ; then

                                                                echo -e "\nYOU HAVE EXCEEDED MAXIMUM ATTEMPTS, PLEASE REFER THE SCRIPT DOCUMENTATION :-() \n"
                                                                exit
                                                        else

                                                                cfgfile_attempt=$((cfgfile_attempt+1))
                                                                echo -e "\nATTEMPT $cfgfile_attempt of 3\n"
                                                                echo -e "\n             EMPTY INPUT :-() \n"
                                                                continue
                                                        fi

                                                        else

                                                                echo $cfgfile >> $cfgfiles
                                                                break
                                                        fi
                                                done

                                        done
                                echo -e "\nTHE PATH YOU GIVEN IS BELOW\n"
                                echo $cfgftppath
                                echo -e "\nTHE FILE(S) YOU GAVEN ARE/IS BELOW "
                                cat $cfgfiles
                                echo -e "\nINFO STORED...."
                                apply_cfg_files="yes"
                                break 2


                        else

                                echo "INAVLID CFG FILE COUNT...TRY AGAIN"
                                continue
                        fi
                break
                done

        elif [[ $opt1 == no ]] ; then

                echo "SKIPPING CFG FILE APPLY....."
                break
        else

                echo "GIVE ME YES OR NO...."
                continue
        fi

done
}





function get_patch_info() {
attempt=0
apply_patch_files="no"
while read -p "DO YOU HAVE ANY OTHER FILES TO PATCH ON SERVER...(yes/no)?:" opt1;
do
        opt1=`echo $opt1 | tr A-Z a-z`
        if [[ -z "$opt1" ]] ; then

                if [ $attempt -gt 2 ] ; then

                        echo -e "\nYOU HAVE EXCEEDED MAXIMUM ATTEMPTS, PLEASE REFER THE SCRIPT DOCUMENTATION :-() \n"
                        exit
                else

                        attempt=$((attempt+1))
                        echo -e "\nATTEMPT $attempt of 3\n"
                        echo -e "\n             EMPTY INPUT :-() \n"
                        continue
                fi

        elif [[ $opt1 == yes ]] ; then
                patch_count_attempt=0

                while read -p "OK...HOW MANY FILES..(ex:1)?:" patch_count;
                do

                        if [[ -z "$patch_count" ]] ; then

                                if [ "$patch_count_attempt" -gt 2 ] ; then
                                        echo -e "\nYOU HAVE EXCEEDED MAXIMUM ATTEMPTS, PLEASE REFER THE SCRIPT DOCUMENTATION :-() \n"
                                        exit
                                else

                                        patch_count_attempt=$((patch_count_attempt+1))
                                        echo -e "\nATTEMPT $patch_count_attempt of 3\n"
                                        echo -e "\n             EMPTY INPUT :-() \n"
                                        continue
                                fi
                        fi

                        if [[ "$patch_count" != *[[:alpha:]]* ]] && [[ $patch_count -ge 1 ]] ; then

                                        patch_path_attempt=0
                                        echo "IF YOU PLANNING TO APPLY MORE PATCH FILES, ALL SHOULD BE UNDER SAME PATH,IF NOT,PLEASE DO IT MANUALLY AND RUN ME AGAIN..."
                                        while read -p "PLEASE GIVE ME THE FTP PATH: " patch_ftp_path;
                                        do
                                                if [[ -z $patch_ftp_path ]] ; then

                                                        if [ "$patch_path_attempt" -gt 2 ] ; then

                                                                echo -e "\nYOU HAVE EXCEEDED MAXIMUM ATTEMPTS, PLEASE REFER THE SCRIPT DOCUMENTATION :-() \n"
                                                                exit
                                                        else

                                                                patch_path_attempt=$((patch_path_attempt+1))
                                                                echo -e "\nATTEMPT $patch_path_attempt of 3\n"
                                                                echo -e "\n             EMPTY INPUT :-() \n"
                                                                continue
                                                        fi
                                                else

                                                        echo "ASSUMING GIVEN PATH IS OK, IF NOT YOU WILL GET ERROR ON FURTHER EXECUTION..."
                                                        break
                                                fi

                                        done

                                        echo "" > $patch_files
                                        echo "" > $patch_local_path
                                        echo "" > $copy_patch_info
                                        for (( i=1; i<=$patch_count; i++ ))
                                        do
                                                patch_file_attempt=0
                                                while read -p "PLEASE GIVE ME FILENAME( $i ): " patch_file;
                                                do

                                                        if [[ -z $patch_file ]] ; then

                                                        if [ "$patch_file_attempt" -gt 2 ] ; then

                                                                echo -e "\nYOU HAVE EXCEEDED MAXIMUM ATTEMPTS, PLEASE REFER THE SCRIPT DOCUMENTATION :-() \n"
                                                                exit
                                                        else

                                                                patch_file_attempt=$((patch_file_attempt+1))
                                                                echo -e "\nATTEMPT $patch_file_attempt of 3\n"
                                                                echo -e "\n             EMPTY INPUT :-() \n"
                                                                continue
                                                        fi

                                                        else
                                                                patch_apply_path_attempt=0
                                                                while read -p "WHERE IT SHOULD BE PLACED(LOCAL PATH)? " patch_apply_path;
                                                                do
                                                                        if [[ -z $patch_apply_path ]] ; then

                                                                                if [ "$patch_apply_path_attempt" -gt 2 ] ; then

                                                                                        echo -e "\nYOU HAVE EXCEEDED MAXIMUM ATTEMPTS, PLEASE REFER THE SCRIPT DOCUMENTATION :-() \n"
                                                                                        exit
                                                                                else

                                                                                        patch_apply_path_attempt=$((patch_apply_path_attempt+1))
                                                                                        echo -e "\nATTEMPT $patch_file_attempt of 3\n"
                                                                                        echo -e "\n             EMPTY INPUT :-() \n"
                                                                                        continue
                                                                                fi
                                                                        fi

                                                                        if [[ ! -d $patch_apply_path ]] ; then

                                                                                while read -p "GIVEN PATH ( $patch_apply_path ) IS NOT PRESENT, YOU WANT ME TO CREATE IT ?" opt2;
                                                                                do

                                                                                        if [[ ! -z $opt2 ]] ; then

                                                                                                if [ "$opt2" == "yes" ] ; then

                                                                                                mkdir -p $patch_apply_path
                                                                                                if [ $? -eq 0 ] ; then
                                                                                                        echo "DIRECTORY CREATED"
                                                                                                        echo $patch_file >> $patch_files
                                                                                                        echo "$patch_apply_path/$patch_file" >> $patch_local_path
                                                                                                        echo "$WORK_DIR"patch/"""$patch_file""=""$patch_apply_path" >> $copy_patch_info
                                                                                                        break 3
                                                                                                else

                                                                                                        echo "UNABLE TO CREATE THE GIVEN PATH,CHECK PERMISSION AND OTHER POSSIBLITIES...".
                                                                                                        exit
                                                                                                fi

                                                                                                elif [ "$opt2" == "no" ] ; then
                                                                                                        echo "WITHOUT CREATING DIRECTORY,CANNOT APPLY THE FILE,,TERMINATING..."
                                                                                                        exit
                                                                                                else

                                                                                                        echo "GIVE ME YES OR NO....PLEASE"
                                                                                                        continue
                                                                                                fi
                                                                                        else
                                                                                                if [ "$opt2_attempt" -gt 2 ] ; then
                                                                                                echo -e "\nYOU HAVE EXCEEDED MAXIMUM ATTEMPTS, PLEASE REFER THE SCRIPT DOCUMENTATION :-() \n"
                                                                                                exit

                                                                                                else
                                                                                                $opt2_attempt=$(($opt2_attempt+1))
                                                                                                echo -e "\nATTEMPT $opt2_attempt of 3\n"
                                                                                                echo -e "\n             EMPTY INPUT :-() \n"
                                                                                                continue
                                                                                                fi

                                                                                        fi


                                                                                done
                                                                        else
                                                                                echo $patch_file >> $patch_files
                                                                                echo "$patch_apply_path/$patch_file" >> $patch_local_path
                                                                                echo "$WORK_DIR"patch/"""$patch_file""=""$patch_apply_path" >> $copy_patch_info
                                                                                break 2

                                                                        fi
                                                                        done

                                                        fi
                                                done

                                        done
                                echo -e "\nTHE FTP PATH YOU GIVEN IS BELOW\n"
                                echo $patch_ftp_path
                                echo -e "\nTHE FILE(S) YOU GAVEN ARE/IS BELOW WITH LOCAL PATH "
                                cat $patch_local_path
                                echo -e "\nINFO STORED...."
                                apply_patch_files="yes"
                                break 2


                        else

                                echo "INAVLID CFG FILE COUNT...TRY AGAIN"
                                continue
                        fi
                break
                done

        elif [[ $opt1 == no ]] ; then

                echo "SKIPPING PATCH FILE APPLY....."
                break
        else

                echo "GIVE ME YES OR NO...."
                continue
        fi

done
}



function download_files() {


function download_conf() {

echo "DOWNLOADING CFG FILES FROM FTP" | tee -a $log
patch_download=""

if [ -d $WORK_DIR"conf" ] ; then rm -rf $WORK_DIR"conf" ; mkdir -p $WORK_DIR"conf" ; cd $WORK_DIR"conf" ; else mkdir -p $WORK_DIR"conf" ; cd $WORK_DIR"conf" ; fi


#files=`cat $cfgfiles | tr '\n' ' '`
files=`cat $cfgfiles | sed /^$/d | sed 's#^#get #g'`

ftp -pinv $FTPSRV << End-Of-Session > ${conf_ftp_log}
user $UNAME $PASSWORD
bin
cd $cfgftppath
prompt off
$files
bye
End-Of-Session
cat ${conf_ftp_log} | grep "$ftp_dir_err"
if [ $? -ne 0 ]
then
cat ${conf_ftp_log} | grep "${ftp_size_err}"
if [ $? -ne 0 ]
then
        echo -e  "CFG FILE(s) DOWNLOADED SUCCESSFULY\n" | tee -a $log
        conf_download=success
else
       echo -e "BELOW FILE(s) NOT PRESENT ON FTP UNDER $cfgftppath , PLEASE CHECK AND RUN ME AGAIN..." | tee -a $log

        lno=`cat $conf_ftp_log | grep -n "550 Failed to open file." | cut -d ":" -f1`
        for i in $lno; do sed -n `echo $((i-2))p` $conf_ftp_log | cut -d ":" -f3 ; done
       exit
fi
else
        echo -e "GIVEN PATH ( $cfgftppath ) IS NOT PRESENT ON FTP,PLEASE CHECK...." | tee -a $log
        exit
fi

}

function download_patch() {


echo "DOWNLOADING PATCH FILES FROM FTP" | tee -a $log
patch_download=""

if [ -d $WORK_DIR"patch" ] ; then rm -rf $WORK_DIR"patch" ; mkdir -p $WORK_DIR"patch" ; cd $WORK_DIR"patch" ; else mkdir -p $WORK_DIR"patch" ; cd $WORK_DIR"patch" ; fi

#files=`cat $cfgfiles | tr '\n' ' '`
files=`cat $patch_files | sed /^$/d | sed 's#^#get #g'`

ftp -pinv $FTPSRV << End-Of-Session > ${patch_ftp_log}
user $UNAME $PASSWORD
bin
cd $patch_ftp_path
prompt off
$files
bye
End-Of-Session
cat ${patch_ftp_log} | grep "$ftp_dir_err"
if [ $? -ne 0 ]
then
cat ${patch_ftp_log} | grep "${ftp_size_err}"
if [ $? -ne 0 ]
then
        echo -e  "PATCH FILE(s) DOWNLOADED SUCCESSFULY\n" | tee -a $log
        patch_download=success
else
       echo -e "BELOW FILE(s) NOT PRESENT ON FTP UNDER $patch_ftp_path , PLEASE CHECK AND RUN ME AGAIN..." | tee -a $log

        lno=`cat $patch_ftp_log | grep -n "550 Failed to open file." | cut -d ":" -f1`
        for i in $lno; do sed -n `echo $((i-2))p` $patch_ftp_log | cut -d ":" -f3 ; done
       exit
fi
else
        echo -e "GIVEN PATH ( $patch_ftp_path ) IS NOT PRESENT ON FTP,PLEASE CHECK...." | tee -a $log
        exit
fi

}




if [[ $apply_cfg_files == "yes" ]] ; then
download_conf
fi

if [[ $apply_patch_files == "yes" ]] ; then
download_patch
fi

}



function apply_files() {


function apply_conf() {

if [ -d $WORK_DIR"backup_files/conf/" ] ; then rm -rf $WORK_DIR"backup_files/conf/" ; mkdir -p $WORK_DIR"backup_files/conf/" ; cd $WORK_DIR"backup_files/conf/" ; else mkdir -p $WORK_DIR"backup_files/conf/" ; cd $WORK_DIR"backup_files/conf/" ; fi
cfg_backup=""
for i in `cat $cfgfiles`
do
ls $CONF_DIR$i >> /dev/null
if [ $? -eq 0 ] ; then
cp $CONF_DIR$i $WORK_DIR"backup_files/conf/"
if [ $? -eq 0 ] ; then
cfg_backup="success"
is_old_there=yes
else
echo "UNABLE TO BACKUP ( $CONF_DIR$i ) to ( $WORK_DIR"backup_files/conf/" ), PLEASE CHECK THE DRIVE SPACE OR OTHER REASONS...,TERMINATING THE SCRIPT "
exit
fi
fi
done

if [ "$is_old_there" == "yes" ] ; then
if [ "$cfg_backup" == "success" ]
then
tar -cvf $BKP_DIR$BKP_CONF_FNAME".tar.gz" $WORK_DIR"backup_files/conf/."
if [ $? -eq 0 ] ;then
echo "CONF FILES ARE BACKED UP............."
else
echo "UNABLE TO BACKUP ( $WORK_DIR"backup_files/conf/" ) to ( $BKP_DIR ), PLEASE CHECK THE DRIVE SPACE, TARRING ISSUE OR OTHER REASONS...,TERMINATING THE SCRIPT "
exit
fi
fi
else
echo "NO OLD CONF FILES FOUND TO BACKUP......"
fi

for i in `cat $cfgfiles`
do
if [ -f "$CONF_DIR$i" ] ; then
rm $CONF_DIR$i
cp $WORK_DIR"conf/$i" $CONF_DIR$i
if [ $? -eq 0 ] ; then
echo "$CONF_DIR$i" is applied
else
echo "UNABLE TO APPLY ( $CONF_DIR$i ) FROM ( $WORK_DIR"conf/$i" ) , PLEASE CHECK THE DRIVE SPACE,OR OTHER REASONS...,TERMINATING THE SCRIPT "
exit
fi
else
cp $WORK_DIR"conf/$i" $CONF_DIR$i
if [ $? -eq 0 ] ; then
echo "$CONF_DIR$i" is applied
else
echo "UNABLE TO APPLY ( $CONF_DIR$i ) FROM ( $WORK_DIR"conf/$i" ) , PLEASE CHECK THE DRIVE SPACE,OR OTHER REASONS...,TERMINATING THE SCRIPT "
exit
fi
fi
done

}

function apply_patch() {

if [ -d $WORK_DIR"backup_files/patch/" ] ; then rm -rf $WORK_DIR"backup_files/patch/" ; mkdir -p $WORK_DIR"backup_files/patch/" ; cd $WORK_DIR"backup_files/patch/" ; else mkdir -p $WORK_DIR"backup_files/patch/" ; cd $WORK_DIR"backup_files/patch/" ; fi
patch_backup=""
for i in `cat $patch_local_path`
do
ls $i >> /dev/null
if [ $? -eq 0 ] ; then
cp $i $WORK_DIR"backup_files/patch/"
if [ $? -eq 0 ] ; then
patch_backup="success"
is_old_patch_there=yes
else
echo "UNABLE TO BACKUP ( $i ) to ( $WORK_DIR"backup_files/patch/" ), PLEASE CHECK THE DRIVE SPACE OR OTHER REASONS...,TERMINATING THE SCRIPT "
exit
fi
fi
done

if [ "$is_old_patch_there" == "yes" ] ; then
if [ "$patch_backup" == "success" ]
then
tar -czvf $BKP_DIR$BKP_PATCH_FNAME".tgz" $WORK_DIR"backup_files/patch/."
if [ $? -eq 0 ] ;then
echo "PATCH FILES ARE BACKED UP............."
else
echo "UNABLE TO BACKUP ( $WORK_DIR"backup_files/patch/" ) to ( $BKP_DIR ), PLEASE CHECK THE DRIVE SPACE, TARRING ISSUE OR OTHER REASONS...,TERMINATING THE SCRIPT "
exit
fi
fi
else
echo "NO PATCHE FILES FOUND TO BACKUP......"
fi

for i in `cat $copy_patch_info`
do
move_file=`echo $i | sed 's#=# #g'`
mv $move_file
if [ $? -eq 0 ] ; then
        echo "$i" "--> applied"
else
echo "UNABLE TO APPLY ( $WORK_DIR"patch/$i" ) , PLEASE CHECK THE DRIVE SPACE,OR OTHER REASONS...,TERMINATING THE SCRIPT "
exit
fi
done


}




if [[ "$conf_download" == "success" ]] ; then
apply_conf
fi

if [[ "$patch_download" == "success" ]] ; then
apply_patch
fi

while read -p "DO YOU HAVE ANY BUNDLES TO APPLY...(yes/no)?:" opt3;
do
	opt3=`echo $opt1 | tr A-Z a-z`
	if [[ -z "$opt3" ]] ; then

                if [ $attempt -gt 2 ] ; then

                        echo -e "\nYOU HAVE EXCEEDED MAXIMUM ATTEMPTS, PLEASE REFER THE SCRIPT DOCUMENTATION :-() \n"
                        exit
                else

                        attempt=$((attempt+1))
                        echo -e "\nATTEMPT $attempt of 3\n"
                        echo -e "\n             EMPTY INPUT :-() \n"
                        continue
                fi
        fi

        if [ "$opt3" == "yes" ] ; then
		
		echo "MOVING TO DEPLOYMENT........."

        elif [ "$opt3" == "no" ] ; then

                        echo "SKIPPING BUNDLES DEPLOYMENT ....."
                        echo "STARTING RE_DEPLOYMENT.........."
                        redeploy
                        break
         else
                        echo "GIVE ME YES OR NO...."
                        continue

         fi

done
}






# Calling required functions

get_conf_info
get_patch_info
download_files
apply_files
pre_check
download_build
stop_karaf
backup_bundle
prepare_build
echo -e "\nSLEEPING FOR A MINUTE"  | tee -a $log
sleep 10
stop_karaf
start_karaf
sleep 30
wst=$(`echo "list" > list && sshpass -p "smx" ssh -t -t -o StrictHostKeyChecking=no -p 8101 smx@localhost < list >  /dev/null`)
start_deploy
deploy_result
