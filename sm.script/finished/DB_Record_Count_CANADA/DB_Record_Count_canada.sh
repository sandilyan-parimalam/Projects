{
UNAME=india
PASSWD=transfer1
FTP_SRVR=216.3.117.138

DTF="18051992"
#DTF="$(date '+%m%d%Y')"
#DTFT="($(date '+%T'))"


FILE_NAME1=canada-RecCount-$DTF.log
FILE_NAME2=canada2-RecCount-$DTF.log
FILE_NAME3=cibc-RecCount-$DTF.log
FILE_NAME4=its-RecCount-$DTF.log
FILE_NAME5=sx-RecCount-$DTF.log

FTP_DIR1=/SmartMonitor/SOOLogs/CANADA/DB_Record_test
FTP_DIR2=/SmartMonitor/SOOLogs/CANADA2/DB_Record_test
FTP_DIR3=/SmartMonitor/SOOLogs/CIBC/DB_Record_test
FTP_DIR4=/SmartMonitor/SOOLogs/SOITS/DB_Record_test
FTP_DIR5=/SmartMonitor/SOOLogs/SX/DB_Record_test

DEST_DIR1=/opt/smartoffice/instances/smnode1/smweb/files/SOOCANADA/tableinfo/in/
DEST_DIR2=/opt/smartoffice/instances/smnode1/smweb/files/SOOCANADA2/tableinfo/in/
DEST_DIR3=/opt/smartoffice/instances/smnode1/smweb/files/CIBC/tableinfo/in/
DEST_DIR4=/opt/smartoffice/instances/smnode1/smweb/files/SOITS/tableinfo/in/
DEST_DIR5=/opt/smartoffice/instances/smnode1/smweb/files/SX/tableinfo/in/


BASE_DIR=/opt/smartoffice/instances/smnode1/bin/custom/maintenance_logs
LOG_DIR="${BASE_DIR}"/logs.recordcount

touch "${LOG_DIR}"/ftp_status_${DTF}.log
touch "${LOG_DIR}"/ftp_err_${DTF}.log

FTP_STATUS_LOG=/opt/smartoffice/instances/smnode1/bin/custom/maintenance_logs/logs.recordcount/ftp_status_${DTF}.log
FTP_ERR_LOG=/opt/smartoffice/instances/smnode1/bin/custom/maintenance_logs/logs.recordcount/ftp_err_${DTF}.log

ARCHIVE_SOOCANADA_DIR=/opt/smartoffice/instances/smnode1/smweb/files/SOOCANADA/tableinfo/archives
ARCHIVE_SOOCANADA2_DIR=/opt/smartoffice/instances/smnode1/smweb/files/SOOCANADA2/tableinfo/archives
ARCHIVE_SOITS_DIR=/opt/smartoffice/instances/smnode1/smweb/files/SOITS/tableinfo/archives
ARCHIVE_CIBC_DIR=/opt/smartoffice/instances/smnode1/smweb/files/CIBC/tableinfo/archives
ARCHIVE_SX_DIR=/opt/smartoffice/instances/smnode1/smweb/files/CIBC/tableinfo/archives





#_____________________________________________________SOCANADA_________________________________________________________________________________________________
cd $DEST_DIR1

ftp -ivn $FTP_SRVR << Session > ${FTP_STATUS_LOG} 2> ${FTP_ERR_LOG}
user ${UNAME} ${PASSWD}
bin
cd "${FTP_DIR1}"
size ${FILE_NAME1}_processed
prompt off
size ${FILE_NAME1}
mget ${FILE_NAME1}
yes
close
bye
Session

FTPCON=$(less $FTP_ERR_LOG | grep -w 4 | cut -c1-3 | head -1)

if [[ -n $FTPCON ]] ; then

        echo "There is a prblem with ftp,please check the attached log files" | mail -a $FTP_STATUS_LOG -a $FTP_ERR_LOG -s "Smartmonitor download process not completed for SOOCANADA" sandilyan.parimalam@mytestorg.com

else

TEMPVAR1=$(less $FTP_STATUS_LOG | grep ${FILE_NAME1}_processed | cut -d ":"  -f2)
TEMPVAR2=" No such file."


if [[ $TEMPVAR1 == $TEMPVAR2 ]] ; then

        less $FTP_STATUS_LOG | grep --word 226
        rc=$?

if [[ $rc = 0 ]] ; then

        VAR1=$(less $FTP_STATUS_LOG | grep -w $FILE_NAME1 | cut -f2 | head -1) 
        VAR2=$(less $FTP_STATUS_LOG | grep "bytes received" | cut -d " " -f1 )
                if [[ $VAR1 -eq $VAR2 ]] ; then

ftp -ivn ${FTP_SRVR} << Session >> ${FTP_STATUS_LOG} 2>> ${FTP_ERR_LOG}
                user ${UNAME} ${PASSWD}
                bin
                cd "${FTP_DIR1}"
                prompt
                rename ${FILE_NAME1} ${FILE_NAME1}_processed
                yes
                close
                bye
Session


                        #echo "Successfully DOWNLOADED and marked as processed"
                else
                        echo "There is a size mismatch of source and destination files, script will try to redownload on next attempt" | mail -a $FTP_STATUS_LOG -a $FTP_ERR_LOG -s "Smartmonitor download process not completed for SOOCANADA" sandilyan.parimalam@mytestorg.com
                fi

        else
                 echo "log still not uploaded on FTP, script will try to redownload on next attempt" | mail -a $FTP_STATUS_LOG -a $FTP_ERR_LOG -s "Smartmonitor download process not completed for SOOCANADA" sandilyan.parimalam@mytestorg.com
        fi

else

        TEMP=$(less $FTP_STATUS_LOG | grep _processed | cut -c39-100)
        if [ -n "$TEMP" ]; then
            #echo "ALREADY DOWNLOADED"
		OP=/dev/null
fi
fi
fi           

cp $LOG_DIR/ftp_status_${DTF}.log $ARCHIVE_SOOCANADA_DIR/ftp_status_${DTF}.log${DTFT}
cp $LOG_DIR/ftp_err_${DTF}.log $ARCHIVE_SOOCANADA_DIR/ftp_err_${DTF}.log${DTFT}

rm $LOG_DIR/ftp_status_${DTF}.log
rm $LOG_DIR/ftp_err_${DTF}.log


#_____________________________________________________SOCANADA2_________________________________________________________________________________________________

touch "${LOG_DIR}"/ftp_status_${DTF}.log
touch "${LOG_DIR}"/ftp_err_${DTF}.log
cd "$DEST_DIR2"
ftp -ivn $FTP_SRVR << Session > ${FTP_STATUS_LOG} 2> ${FTP_ERR_LOG}
user ${UNAME} ${PASSWD}
bin
cd "${FTP_DIR2}"
size ${FILE_NAME2}_processed
prompt off
size ${FILE_NAME2}
mget ${FILE_NAME2}
yes
close
bye
Session

FTPCON=$(less $FTP_ERR_LOG | grep -w 4 | cut -c1-3 | head -1)

if [[ -n $FTPCON ]] ; then

        echo "There is a prblem with ftp,please check the attached log files" | mail -a $FTP_STATUS_LOG -a $FTP_ERR_LOG -s "Smartmonitor download process not completed for SOOCANADA2" sandilyan.parimalam@mytestorg.com

else

TEMPVAR1=$(less $FTP_STATUS_LOG | grep ${FILE_NAME2}_processed | cut -d ":"  -f2)
TEMPVAR2=" No such file."


	if [[ $TEMPVAR1 == $TEMPVAR2 ]] ; then

		less $FTP_STATUS_LOG | grep --word 226
		rc=$?

			if [[ $rc = 0 ]] ; then

			        VAR1=$(less $FTP_STATUS_LOG | grep -w $FILE_NAME2 | cut -f2 | head -1) 
			        VAR2=$(less $FTP_STATUS_LOG | grep "bytes received" | cut -d " " -f1 )
			                if [[ $VAR1 -eq $VAR2 ]] ; then

ftp -ivn ${FTP_SRVR} << Session >> ${FTP_STATUS_LOG} 2>> ${FTP_ERR_LOG}
                user ${UNAME} ${PASSWD}
                bin
                cd "${FTP_DIR2}"
                prompt
                rename ${FILE_NAME2} ${FILE_NAME2}_processed
                yes
                close
                bye
Session


				#echo "Successfully DOWNLOADED and marked as processed"
			else
				echo "There is a size mismatch of source and destination files, script will try to redownload on next attempt" | mail -a $FTP_STATUS_LOG -a $FTP_ERR_LOG -s "Smartmonitor download process not completed for SOOCANADA2" sandilyan.parimalam@mytestorg.com
		fi

        else
                 echo "log still not uploaded on FTP, script will try to redownload on next attempt" | mail -a $FTP_STATUS_LOG -a $FTP_ERR_LOG -s "Smartmonitor download process not completed for SOOCANADA2" sandilyan.parimalam@mytestorg.com
        fi

else

        TEMP=$(less $FTP_STATUS_LOG | grep _processed | cut -d ":"  -f2 )
        if [ -n "$TEMP" ]; then
            #echo "ALREADY DOWNLOADED"
                OP=/dev/null

fi
fi
fi                                        

cp $LOG_DIR/ftp_status_${DTF}.log $ARCHIVE_SOOCANADA2_DIR/ftp_status_${DTF}.log${DTFT}
cp $LOG_DIR/ftp_err_${DTF}.log $ARCHIVE_SOOCANADA2_DIR/ftp_err_${DTF}.log${DTFT}

rm $LOG_DIR/ftp_status_${DTF}.log
rm $LOG_DIR/ftp_err_${DTF}.log


#_____________________________________________________SOITS_________________________________________________________________________________________________

touch "${LOG_DIR}"/ftp_status_${DTF}.log
touch "${LOG_DIR}"/ftp_err_${DTF}.log
cd "$DEST_DIR3"
ftp -ivn $FTP_SRVR << Session > ${FTP_STATUS_LOG} 2> ${FTP_ERR_LOG}
user ${UNAME} ${PASSWD}
bin
cd "${FTP_DIR3}"
size ${FILE_NAME3}_processed
prompt off
size ${FILE_NAME3}
mget ${FILE_NAME3}
yes
close
bye
Session

FTPCON=$(less $FTP_ERR_LOG | grep -w 4 | cut -c1-3 | head -1)

if [[ -n $FTPCON ]] ; then

        echo "There is a prblem with ftp,please check the attached log files" | mail -a $FTP_STATUS_LOG -a $FTP_ERR_LOG -s "Smartmonitor download process not completed for SOITS" sandilyan.parimalam@mytestorg.com

else

TEMPVAR1=$(less $FTP_STATUS_LOG | grep ${FILE_NAME3}_processed | cut -d ":"  -f2)
TEMPVAR2=" No such file."


	if [[ $TEMPVAR1 == $TEMPVAR2 ]] ; then

		less $FTP_STATUS_LOG | grep --word 226
		rc=$?

			if [[ $rc = 0 ]] ; then

			        VAR1=$(less $FTP_STATUS_LOG | grep -w $FILE_NAME3 | cut -f2 | head -1) 
			        VAR2=$(less $FTP_STATUS_LOG | grep "bytes received" | cut -d " " -f1 )
			                if [[ $VAR1 -eq $VAR2 ]] ; then

ftp -ivn ${FTP_SRVR} << Session >> ${FTP_STATUS_LOG} 2>> ${FTP_ERR_LOG}
                user ${UNAME} ${PASSWD}
                bin
                cd "${FTP_DIR3}"
                prompt
                rename ${FILE_NAME3} ${FILE_NAME3}_processed
                yes
                close
                bye
Session


				#echo "Successfully DOWNLOADED and marked as processed"
			else
				echo "There is a size mismatch of source and destination files, script will try to redownload on next attempt" | mail -a $FTP_STATUS_LOG -a $FTP_ERR_LOG -s "Smartmonitor download process not completed for SOITS" sandilyan.parimalam@mytestorg.com
		fi

        else
                 echo "log still not uploaded on FTP, script will try to redownload on next attempt" | mail -a $FTP_STATUS_LOG -a $FTP_ERR_LOG -s "Smartmonitor download process not completed for SOITS" sandilyan.parimalam@mytestorg.com
        fi

else

        TEMP=$(less $FTP_STATUS_LOG | grep _processed | cut -d ":"  -f2 )
        if [ -n "$TEMP" ]; then
            #echo "ALREADY DOWNLOADED"
                OP=/dev/null

fi
fi
fi                                        

cp $LOG_DIR/ftp_status_${DTF}.log $ARCHIVE_SOITS_DIR/ftp_status_${DTF}.log${DTFT}
cp $LOG_DIR/ftp_err_${DTF}.log $ARCHIVE_SOITS_DIR/ftp_err_${DTF}.log${DTFT}

rm $LOG_DIR/ftp_status_${DTF}.log
rm $LOG_DIR/ftp_err_${DTF}.log


                             
#_____________________________________________________CIBC_________________________________________________________________________________________________

touch "${LOG_DIR}"/ftp_status_${DTF}.log
touch "${LOG_DIR}"/ftp_err_${DTF}.log
cd "$DEST_DIR4"
ftp -ivn $FTP_SRVR << Session > ${FTP_STATUS_LOG} 2> ${FTP_ERR_LOG}
user ${UNAME} ${PASSWD}
bin
cd "${FTP_DIR4}"
size ${FILE_NAME4}_processed
prompt off
size ${FILE_NAME4}
mget ${FILE_NAME4}
yes
close
bye
Session

FTPCON=$(less $FTP_ERR_LOG | grep -w 4 | cut -c1-3 | head -1)

if [[ -n $FTPCON ]] ; then

        echo "There is a prblem with ftp,please check the attached log files" | mail -a $FTP_STATUS_LOG -a $FTP_ERR_LOG -s "Smartmonitor download process not completed for CIBC" sandilyan.parimalam@mytestorg.com

else

TEMPVAR1=$(less $FTP_STATUS_LOG | grep ${FILE_NAME4}_processed | cut -d ":"  -f2)
TEMPVAR2=" No such file."


	if [[ $TEMPVAR1 == $TEMPVAR2 ]] ; then

		less $FTP_STATUS_LOG | grep --word 226
		rc=$?

			if [[ $rc = 0 ]] ; then

			        VAR1=$(less $FTP_STATUS_LOG | grep -w $FILE_NAME4 | cut -f2 | head -1) 
			        VAR2=$(less $FTP_STATUS_LOG | grep "bytes received" | cut -d " " -f1 )
			                if [[ $VAR1 -eq $VAR2 ]] ; then

ftp -ivn ${FTP_SRVR} << Session >> ${FTP_STATUS_LOG} 2>> ${FTP_ERR_LOG}
                user ${UNAME} ${PASSWD}
                bin
                cd "${FTP_DIR4}"
                prompt
                rename ${FILE_NAME4} ${FILE_NAME4}_processed
                yes
                close
                bye
Session


				#echo "Successfully DOWNLOADED and marked as processed"
			else
				echo "There is a size mismatch of source and destination files, script will try to redownload on next attempt" | mail -a $FTP_STATUS_LOG -a $FTP_ERR_LOG -s "Smartmonitor download process not completed for CIBC" sandilyan.parimalam@mytestorg.com
		fi

        else
                 echo "log still not uploaded on FTP, script will try to redownload on next attempt" | mail -a $FTP_STATUS_LOG -a $FTP_ERR_LOG -s "Smartmonitor download process not completed for CIBC" sandilyan.parimalam@mytestorg.com
        fi

else

        TEMP=$(less $FTP_STATUS_LOG | grep _processed | cut -d ":"  -f2 )
        if [ -n "$TEMP" ]; then
            #echo "ALREADY DOWNLOADED"
                OP=/dev/null

	
fi
fi
fi                                        

cp $LOG_DIR/ftp_status_${DTF}.log $ARCHIVE_CIBC_DIR/ftp_status_${DTF}.log${DTFT}
cp $LOG_DIR/ftp_err_${DTF}.log $ARCHIVE_CIBC_DIR/ftp_err_${DTF}.log${DTFT}

rm $LOG_DIR/ftp_status_${DTF}.log
rm $LOG_DIR/ftp_err_${DTF}.log



#_____________________________________________________SX_________________________________________________________________________________________________

touch "${LOG_DIR}"/ftp_status_${DTF}.log
touch "${LOG_DIR}"/ftp_err_${DTF}.log
cd "$DEST_DIR5"
ftp -ivn $FTP_SRVR << Session > ${FTP_STATUS_LOG} 2> ${FTP_ERR_LOG}
user ${UNAME} ${PASSWD}
bin
cd "${FTP_DIR5}"
size ${FILE_NAME5}_processed
prompt off
size ${FILE_NAME5}
mget ${FILE_NAME5}
yes
close
bye
Session

FTPCON=$(less $FTP_ERR_LOG | grep -w 4 | cut -c1-3 | head -1)

if [[ -n $FTPCON ]] ; then

        echo "There is a prblem with ftp,please check the attached log files" | mail -a $FTP_STATUS_LOG -a $FTP_ERR_LOG -s "Smartmonitor download process not completed for SX" sandilyan.parimalam@mytestorg.com

else

TEMPVAR1=$(less $FTP_STATUS_LOG | grep ${FILE_NAME5}_processed | cut -d ":"  -f2)
TEMPVAR2=" No such file."


	if [[ $TEMPVAR1 == $TEMPVAR2 ]] ; then

		less $FTP_STATUS_LOG | grep --word 226
		rc=$?

			if [[ $rc = 0 ]] ; then

			        VAR1=$(less $FTP_STATUS_LOG | grep -w $FILE_NAME5 | cut -f2 | head -1) 
			        VAR2=$(less $FTP_STATUS_LOG | grep "bytes received" | cut -d " " -f1 )
			                if [[ $VAR1 -eq $VAR2 ]] ; then

ftp -ivn ${FTP_SRVR} << Session >> ${FTP_STATUS_LOG} 2>> ${FTP_ERR_LOG}
                user ${UNAME} ${PASSWD}
                bin
                cd "${FTP_DIR5}"
                prompt
                rename ${FILE_NAME5} ${FILE_NAME5}_processed
                yes
                close
                bye
Session


				#echo "Successfully DOWNLOADED and marked as processed"
			else
				echo "There is a size mismatch of source and destination files, script will try to redownload on next attempt" | mail -a $FTP_STATUS_LOG -a $FTP_ERR_LOG -s "Smartmonitor download process not completed for SX" sandilyan.parimalam@mytestorg.com
		fi

        else
                 echo "log still not uploaded on FTP, script will try to redownload on next attempt" | mail -a $FTP_STATUS_LOG -a $FTP_ERR_LOG -s "Smartmonitor download process not completed for SX" sandilyan.parimalam@mytestorg.com
        fi

else

        TEMP=$(less $FTP_STATUS_LOG | grep _processed | cut -d ":"  -f2 )
        if [ -n "$TEMP" ]; then
            #echo "ALREADY DOWNLOADED"
                OP=/dev/null

fi
fi
fi                                        

cp $LOG_DIR/ftp_status_${DTF}.log $ARCHIVE_SX_DIR/ftp_status_${DTF}.log${DTFT}
cp $LOG_DIR/ftp_err_${DTF}.log $ARCHIVE_SX_DIR/ftp_err_${DTF}.log${DTFT}

rm $LOG_DIR/ftp_status_${DTF}.log
rm $LOG_DIR/ftp_err_${DTF}.log

} > /dev/null
                             

