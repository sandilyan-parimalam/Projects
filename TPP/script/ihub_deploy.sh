						#################################################################
						#	Author		:	P.sandilyan,HSG			#
						#	Description	:	Script for I-HUB deployment	#
						#################################################################


#	including conf file
if [ -f "/opt/tppihub/iHub/script/ihub_deploy.conf" ] ; then
source /opt/tppihub/iHub/script/ihub_deploy.conf
else
echo "CONF FILE NOT FOUND, PLEASE PLACE THE PROPER CONF FILE AND RETRY"
exit
fi

#	Handy Varriables

declare -a deploy_files
build_jar_count=0




#	Function declarations

function download_build() {

attempt=0
echo
while read -p "ENTER THE FTP PATH OF THE BUILD ( WITH TRAILING SLASH "/" )" a; 
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
		echo
                while read -p "ENTER THE ZIP FILE NAME TO BE DEPLOYED:" b;
                do
                        if [[ -z "${b}" ]]
                        then
                        {
                                if [ $attempt -gt 2 ]
                                then
                                echo -e "n\nYOU HAVE EXCEEDED MAXIMUM ATTEMPTS PLEASE REFER THE SCRIPT DOCUMENTATION :-() \n"
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
				cat ${ftp_log} | grep "Failed to open file"
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
echo -e "\n STOPPING KARAF SERVICE\n" | tee -a $log
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
echo -e "\n STARTING KARAF SERVICE\n" | tee -a $log
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

/*
# storing conf files
cd $BLD_DIR
tmp_conf_files=$(ls *.conf)
build_conf_count=0
declare -a build_conf_files

for i in $tmp_conf_files
do
build_conf_files[build_conf_count++]=$i
done
echo
echo "$build_conf_count conf files in the build"
echo ${build_conf_files[*]}
*/


# Replacing new jar bundles with old

cd $BLD_DIR
tmp_jar_files=$(ls *.jar)
build_jar_count=0
confirm_value=0
declare -a build_jar_file
for i in $tmp_jar_files
do
build_jar_files[build_jar_count++]=$i
target_file=$(echo "$DEPLOY_WORK_DIR`echo $i | rev | cut -d "-" -f2- | rev`"*)
source_file=$(echo "$BLD_DIR`echo $i | rev | cut -d "-" -f2- | rev`"*)
if [ -f "$target_file" ]
then
{
echo -e "\n\e[1;31m DELETING EXISTING BUNDLE $target_file \e[0m" | tee -a $log
rm  $target_file
echo -e "\nINSERTING NEW BUNDLE "$target_file | tee -a $log
cp $source_file $target_file
if [ $? -eq 0 ] ; then
{
	confirm_value=1
}
fi

}
else
{
echo -e " \nINSERTING NEW BUNDLE"$target_file | tee -a $log
cp $source_file $target_file
if [ $? -eq 0 ] ; then
{
        confirm_value=1
}
fi



}
fi
done


if [ $confirm_value -eq 1 ] ; then
{
start_karaf

}
else
{

echo -e "\nThere is problem with mingiling new jar bundles with existing " | tee -a $log
echo -e "\njar files under $BLD_DIR are not replaced or placed with the files under $DEPLOY_WORK_DIR" | tee -a $log
echo -e "\n!!!!!!!!!!!!!!!!!!!!!!!!PLEASE REVERT THE DEPLOYMENT MANUALY, BACKUP OF DEPLOY DIR IS UNDER $BKP_DIR !!!!!!!!!!!!!!!!!!!!!!!!!!" | tee -a $log
exit
}
fi

}




function prepare_deploy() {

deploy_files=$( ls $DEPLOY_WORK_DIR )
declare -a final_deploy_files
deploy_files_count=0

for i in $deploy_files
do

final_deploy_files[deploy_files_count++]=$i
done
echo -e "\n******************************************************** STARTING DEPLOYMENT ***********************************************************" | tee -a $log
}



function start_deploy() {

for i in `echo $DPLY_ORDER`
do
src_file=`echo $DEPLOY_WORK_DIR$i"*"`
cp  $src_file $DPLY_DIR
sleep 20
if [ $? -eq 0 ]
then
{
echo -e "\n"${src_file}" -------------->  DEPLOYED SUCCESSFULLY"  | tee -a $log
}
else
{
echo  -a "\n"${src_file}" -------------->  FILED TO DEPLOY" | tee -a $log
}
fi

done


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



if [ ! -d $WORK_DIR ] ; then
{
        echo -e "\nCREATING WORK DIR" | tee -a $log
        mkdir $WORK_DIR

}
else
{
echo
echo -e "\nCLEARING WORK DIR" | tee -a $log
rm -rf $WORK_DIR
mkdir $WORK_DIR
}
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
echo -e "\nSLEEPING FOR A MINUTE" | tee -a $log
sleep 50
echo -e "\nCHECKING DEPLOYMENT RESULT" | tee -a $log
while echo "list" > list && sshpass -p "smx" ssh -t -t -o StrictHostKeyChecking=no -p 8101 smx@${SRV_IP} < list | tail -17 > ${temp_log}
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
				if [ $i -eq 1 ]
				then
				echo -e "\nDEPLOYMENT FAILED. SOME OF THE BUNDLES STILL NOT STARTED, PLEASE VERIFY" | tee -a $log
				break 2
				else
				echo -e "\nWAITING FOR ONE MORE MINUTE, SINCE ALL BUNDLES ARE NOT YET STARTED " | tee -a $log
				sleep $i
				continue 2
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


# Calling required functions

download_build
stop_karaf
backup_bundle
prepare_build
echo -e "\n SLEEPING FOR A MINUTE"  | tee -a $log
sleep 60
stop_karaf
start_karaf
sleep 5
prepare_deploy
start_deploy
deploy_result
