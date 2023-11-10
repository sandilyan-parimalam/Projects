UNAME=india
PASSWD=transfer1
FTP_SRVR=216.3.117.138

DTF="18051992"
#DTF="$(date '+%m%d%Y')"

FILE_NAME1=canada-RecCount-$DTF.log
FILE_NAME2=canada2-RecCount-$DTF.log
FILE_NAME3=cibc-RecCount-$DTF.log
FILE_NAME4=its-RecCount-$DTF.log
FILE_NAME5=sx-RecCount-$DTF.log

FTP_DIR1=/SmartMonitor/SOOLogs/CANADA/DB_Record
FTP_DIR2=/SmartMonitor/SOOLogs/CANADA2/DB_Record
FTP_DIR3=/SmartMonitor/SOOLogs/CIBC/DB_Record
FTP_DIR4=/SmartMonitor/SOOLogs/SOITS/DB_Record
FTP_DIR5=/SmartMonitor/SOOLogs/SX/DB_Record

DEST_DIR1=/opt/smartoffice/instances/smnode1/smweb/files/SOOCANADA/tableinfo/in/
DEST_DIR2=/opt/smartoffice/instances/smnode1/smweb/files/SOOCANADA2/tableinfo/in/
DEST_DIR3=/opt/smartoffice/instances/smnode1/smweb/files/CIBC/tableinfo/in/
DEST_DIR4=/opt/smartoffice/instances/smnode1/smweb/files/SOITS/tableinfo/in/
DEST_DIR5=/opt/smartoffice/instances/smnode1/smweb/files/SX/tableinfo/in/

BASE_DIR="/opt/smartoffice/instances/smnode1/bin/custom/db_record_count"
LOG_DIR="${BASE_DIR}"/logs
ARCHIVE_DIR="${BASE_DIR}"/archive



cd $ARCHIVE_DIR

ftp -ivn ${FTP_SRVR} << Session >> ${LOG_DIR}/ftp_status_${DTF}.txt 2>> ${LOG_DIR}/ftp_err_${DTF}.txt
user ${UNAME} ${PASSWD}
bin
cd "${FTP_DIR1}"
prompt
mget ${FILE_NAME1}
yes
close
bye
Session

cp ${FILE_NAME1} ${DEST_DIR1}

ftp -ivn ${FTP_SRVR} << Session >> ${LOG_DIR}/ftp_status_${DTF}.txt 2>> ${LOG_DIR}/ftp_err_${DTF}.txt
user ${UNAME} ${PASSWD}
bin
cd "${FTP_DIR2}"
prompt
mget ${FILE_NAME2}
yes
close
bye
Session

cp ${FILE_NAME2} ${DEST_DIR2}


ftp -ivn ${FTP_SRVR} << Session >> ${LOG_DIR}/ftp_status_${DTF}.txt 2>> ${LOG_DIR}/ftp_err_${DTF}.txt
user ${UNAME} ${PASSWD}
bin
cd "${FTP_DIR3}"
prompt
mget ${FILE_NAME3}
yes
close
bye
Session

cp ${FILE_NAME3} ${DEST_DIR3}

ftp -ivn ${FTP_SRVR} << Session >> ${LOG_DIR}/ftp_status_${DTF}.txt 2>> ${LOG_DIR}/ftp_err_${DTF}.txt
user ${UNAME} ${PASSWD}
bin
cd "${FTP_DIR4}"
prompt
mget ${FILE_NAME4}
yes
close
bye
Session

cp ${FILE_NAME4} ${DEST_DIR4}

ftp -ivn ${FTP_SRVR} << Session >> ${LOG_DIR}/ftp_status_${DTF}.txt 2>> ${LOG_DIR}/ftp_err_${DTF}.txt
user ${UNAME} ${PASSWD}
bin
cd "${FTP_DIR5}"
prompt
mget ${FILE_NAME5}
yes
close
bye
Session

cp ${FILE_NAME5} ${DEST_DIR5}
