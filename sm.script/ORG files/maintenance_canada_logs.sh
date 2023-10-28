UNAME=india
PASSWD=transfer1
FTP_SRVR=216.3.117.138

#DTF="20120203"
DTF="$(date '+%Y%m%d')"

FILE_NAME1=canada-maintlog-$DTF.log
FILE_NAME2=canada2-maintlog-$DTF.log
FILE_NAME3=its-maintlog-$DTF.log
FILE_NAME4=cibc-maintlog-${DTF}.log

FTP_DIR1=/SmartMonitor/SOOLogs/CANADA/Maintenance_Log
FTP_DIR2=/SmartMonitor/SOOLogs/CANADA2/Maintenance_Log
FTP_DIR3=/SmartMonitor/SOOLogs/SOITS/Maintenance_Log
FTP_DIR4=/SmartMonitor/SOOLogs/CIBC/Maintenance_Log

DEST_DIR1=/opt/smartoffice/instances/smnode1/smweb/files/SOOCANADA/maintenancelog/in/
DEST_DIR2=/opt/smartoffice/instances/smnode1/smweb/files/SOOCANADA2/maintenancelog/in/
DEST_DIR3=/opt/smartoffice/instances/smnode1/smweb/files/SOITS/maintenancelog/in/
DEST_DIR4=/opt/smartoffice/instances/smnode1/smweb/files/CIBC/maintenancelog/in/

BASE_DIR="/opt/smartoffice/instances/smnode1/bin/custom/maintenance_logs"
LOG_DIR="${BASE_DIR}"/logs
ARCHIVE_DIR="${BASE_DIR}"/archive

# uploading db record log to ftp site for analysis

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
