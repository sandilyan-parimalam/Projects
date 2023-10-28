#!/bin/bash
#########################################################################################################
#DESCRIBTION:This scripts developed to feed  SM DB_Record_Count logs into SmartMonitor application	#
#AUTHOR:Sandy												#
#IMPLEMETED DATE:4th Jully 2014										#
#########################################################################################################

source /opt/smartoffice/scripts/sm_log_feed/record_count/record_count.conf
for ENV in ${ENVLIST}
do
echo environment $ENV

##################################### Fetching Variables from Conf file ###############################
TENV=`echo ${ENV} | tr a-z A-Z`									      #
SOURCE_SERVER=$(eval 'echo $'${ENV}_SOURCE_SERVER) #---->Dynamic Varriable			      #
TARGET_SERVER=$(eval 'echo '$TARGET_SERVER)							      #
SOURCE_PATH=$(eval 'echo '$SOURCE_PATH)								      #
TEMP_TARGET_PATH=$(eval 'echo '$TEMP_TARGET_PATH)						      #	
TARGET_PATH=$(eval 'echo $'TARGET_PATH1)${TENV}$(eval 'echo $'TARGET_PATH2) #-----> Dynamic varriable #
FNAME=${ENV}-$(eval 'echo '$FNAME1) #----->Dynamic varriable					      #
#######################################################################################################


######################################### FOR EXCEPTIONAL ENV's PATH ############################
source /opt/smartoffice/scripts/sm_log_feed/record_count/record_count_exceptional.sh		#
#################################################################################################
												
												
ssh root@$SOURCE_SERVER test -f "${SOURCE_PATH}${FNAME}"
if [ $? -eq 0 ]
then
	ssh root@$TARGET_SERVER test -f "${TEMP_TARGET_PATH}${FNAME}.processed"
		if [ $? -eq 1 ]
		then
			scp root@$SOURCE_SERVER:"${SOURCE_PATH}${FNAME}" /opt/smartoffice/SM_Logs/temp
				if [ $? -eq 0 ]
				then
					SSIZE=$(ssh root@${SOURCE_SERVER} du -s "${SOURCE_PATH}${FNAME}"|cut -f1)
					LSIZE=$(du -s "/opt/smartoffice/SM_Logs/temp/${FNAME}"|cut -f1)
						if [ $SSIZE -eq $LSIZE ]
						then
							scp /opt/smartoffice/SM_Logs/temp/${FNAME} root@$TARGET_SERVER:"${TEMP_TARGET_PATH}${FNAME}"
							echo "Return code of "$ENV "is " $?
								if [ $? -eq 0 ]
								then
									SSIZE=$(ssh root@${SOURCE_SERVER} du -s "${SOURCE_PATH}${FNAME}"|cut -f1)
									DSIZE=$(ssh root@${TARGET_SERVER} du -s "${TEMP_TARGET_PATH}${FNAME}"|cut -f1)
										if [ $SSIZE -eq $DSIZE ]
										then
											ssh root@$TARGET_SERVER cp "${TEMP_TARGET_PATH}${FNAME}" "${TARGET_PATH}${FNAME}"
												if [ $? -eq 0 ]
												then
													ssh root@$TARGET_SERVER mv "${TEMP_TARGET_PATH}${FNAME}" "${TEMP_TARGET_PATH}${FNAME}.processed"
													rm /opt/smartoffice/SM_Logs/temp/${FNAME}
													echo "file transfered successfully and renamed as processed"
												else
													echo "transfered file not successfully  copied from temp dir to 'in' dir"
													echo "there is problem with copying transfered file from temp dir to 'in' dir. Script will retry the same in next schedule  " | mail -s "Smartmonitor feeding process completed with a copy related error for $ENV " sandilyan.parimalam@mytestorg.com
												fi
										else
											echo "there is problem with renaming the transfered file"
											echo "there is problem with renaming the transfered file. Script will retry the same in next schedule " | mail -s  "Smartmonitor feeding process completed with partial error for $ENV " sandilyan.parimalam@mytestorg.com
										fi
								else
									echo "${FNAME} file not properly copied from ${SOURCE_SERVER} to ${TARGET_SERVER}, there is a problem in SCP"
									echo "${FNAME} file not properly copied from ${SOURCE_SERVER} to ${TARGET_SERVER}. There is source and target file size mismatch after transfer. Script will try to download the same in next schedule " | mail -s  "Smartmonitor feeding process NOT COMPLETED  for $ENV " sandilyan.parimalam@mytestorg.com
								fi
						else
							echo "${FNAME} file not properly copied from ${SOURCE_SERVER} to SXA8. There is a source and target file size mismatch after the first level transfer. Script will try to download the same in next schedule " | mail -s  "Smartmonitor feeding process NOT COMPLETED  for $ENV " sandilyan.parimalam@mytestorg.com
						fi
				
				else
					echo "${FNAME} file not properly copied from ${SOURCE_SERVER} to SXA8. There is a problem with  first level transfer. Script will try to download the same in next schedule  " | mail -s  "Smartmonitor feeding process NOT COMPLETED  for $ENV " sandilyan.parimalam@mytestorg.com
				fi
		else
			echo "FILE ALREADY DOWNLOADED"
		fi
else
	echo " there is no source file "
	echo "${FNAME} file not properly copied from ${SOURCE_SERVER} to ${TARGET_SERVER}. ${FNAME} is not generated on  ${SOURCE_SERVER}.Script will retry on next attempt" | mail -s  "Smartmonitor feeding process NOT COMPLETED  for $ENV " sandilyan.parimalam@mytestorg.com
fi
done

