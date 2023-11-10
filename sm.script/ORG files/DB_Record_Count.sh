#!/bin/bash

set -x

source "/opt/smartoffice/instances/smnode1/bin/custom/db_record_count/conf/db_record_count_new.conf"
CUR_DATE="$(/bin/date '+%m-%d-%Y')"
COUNT=0

cd ${LOG_DIR}

log_func ()
{
        echo [$(date '+%F %T %a (%w)') $(whoami) ] "$@" >> ${LOG_DIR}/db_record_count_status-${DTF}.txt 2>> ${LOG_DIR}/db_record_count_err-${DTF}.txt
}

sendamail_func ()
{

/usr/local/bin/sendEmail -xu smartmonitor@mytestorg.com -xp smartmonitor -t $TO -cc $CC  -u "DB RECORD COUNT REPORT as of ${CUR_DATE}" -f smartmonitor@mytestorg.com -s smtp.emailsrvr.com:587 -o message-file="/opt/smartoffice/instances/smnode1/bin/custom/db_record_count/html/DB_RECORD_COUNT_REPORT-${DTF}.html" -a "/opt/smartoffice/instances/smnode1/bin/custom/db_record_count/html/DB_RECORD_COUNT_REPORT-${DTF}.html"
}

echo "<html><body><title>DB RECORD COUNT REPORT STATUS.</title>
<h3>DB RECORD COUNT REPORT as of ${CUR_DATE}</h3>
<br>
<h4>DB RECORD COUNT REPORT Summary</h4>
<br>
<table border="1" bgcolor="#CCCC66">
<tr>
<th>Sl.No.</th>
<th align=left>EVIRONMENT NAME</th>
<th>STATUS</th>
</tr>" > "/opt/smartoffice/instances/smnode1/bin/custom/db_record_count/html/DB_RECORD_COUNT_REPORT-${DTF}.html"

HTML_REP1 ()
{
echo "<tr>
<td>${COUNT}</td>
<td align=left>${u_ENV}</td>
<font color="#006600"> <td>${status}</td> </font>
</tr>" >> "/opt/smartoffice/instances/smnode1/bin/custom/db_record_count/html/DB_RECORD_COUNT_REPORT-${DTF}.html"
}

HTML_REP2 ()
{
echo "<tr>
<td>${COUNT}</td>
<td align=left>${u_ENV}</td>
<font color="#990000"> <td>${status}</td> </font>
</tr>" >> "/opt/smartoffice/instances/smnode1/bin/custom/db_record_count/html/DB_RECORD_COUNT_REPORT-${DTF}.html"
}

if [ ! -e ${LOG_DIR} ]
then
        log_func "\"${LOG_DIR}\" Log directory doesn't exist."
        mkdir -p ${LOG_DIR}
        if [ $? -eq 0 ]
        then
                echo "Log directory \"${LOG_DIR}\" created successfully."
        else
                echo "Failed to create Log directory \"${LOG_DIR}\""
        fi
else
        echo "Log directory \"${LOG_DIR}\" already exist."
fi

for ENV in ${HOSTS}
do
if [ $ENV = myso3 ]
then
SERVER_NAME=axd5
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/${u_ENV}/tableinfo/in
elif [ $ENV = myso6 ]
then
SERVER_NAME=axd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/${u_ENV}/tableinfo/in
elif [ $ENV = tdbank ]
then
SERVER_NAME=axd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/${u_ENV}/tableinfo/in
elif [ $ENV = dxo ]
then
SERVER_NAME=pxd2
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/DXO/tableinfo/in
elif [ $ENV = china ]
then
SERVER_NAME=axd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/SOCHINA/tableinfo/in
elif [ $ENV = japan ]
then
SERVER_NAME=axd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/JAPAN/tableinfo/in
elif [ $ENV = singapor ]
then
SERVER_NAME=axd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/SINGAPORE/tableinfo/in
elif [ $ENV = pplus ]
then
SERVER_NAME=axd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/SOPREMIER/tableinfo/in
elif [ $ENV = ffg ]
then
SERVER_NAME=axd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/FFG_PROD/tableinfo/in
elif [ $ENV = penn ]
then
SERVER_NAME=sxd9
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/${u_ENV}/tableinfo/in
elif [ $ENV = mfin ]
then
SERVER_NAME=sxd9
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MFINANCIAL/tableinfo/in
elif [ $ENV = kofcdr ]
then
SERVER_NAME=sxd9
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/KOFC_DR/tableinfo/in
elif [ $ENV = myso4dr ]
then
SERVER_NAME=sxd9
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MYSO4_DR/tableinfo/in
elif [ $ENV = myso4 ]
then
SERVER_NAME=axd9
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/${u_ENV}/tableinfo/in
elif [ $ENV = kofc ]
then
SERVER_NAME=axd9
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/${u_ENV}/tableinfo/in
elif [ $ENV = mfindr ]
then
SERVER_NAME=pxd16
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=mfinsp-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MFINANCIAL_DR/tableinfo/in
elif [ $ENV = penndr ]
then
SERVER_NAME=pxd16
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/PENN_DR/tableinfo/in
elif [ $ENV = jhfn ]
then
SERVER_NAME=axd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/JHFN/tableinfo/in
elif [ $ENV = hsbc ]
then
SERVER_NAME=axd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/HSBC/tableinfo/in
elif [ $ENV = myso ]
then
SERVER_NAME=axd5
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MYSO/tableinfo/in
elif [ $ENV = myso2 ]
then
SERVER_NAME=axd5
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MYSO2/tableinfo/in
elif [ $ENV = smonitor ]
then
SERVER_NAME=axd4
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/SMARTMONITOR/tableinfo/in
elif [ $ENV = myso5 ]
then
SERVER_NAME=axd4
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MYSO5/tableinfo/in
elif [ $ENV = fullsail ]
then
SERVER_NAME=pxd2
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=fullsail-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/DXO_1_0/tableinfo/in
elif [ $ENV = mysodr ]
then
SERVER_NAME=sxd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=mysodr-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MYSODR/tableinfo/in
elif [ $ENV = myso2dr ]
then
SERVER_NAME=sxd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=myso2dr-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MYSO2DR/tableinfo/in
elif [ $ENV = myso3dr ]
then
SERVER_NAME=sxd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=myso3dr-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MYSO3DR/tableinfo/in
elif [ $ENV = mysql ]
then
SERVER_NAME=pxw10
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=MYSQL-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/backup/mysql/scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MYSQL/tableinfo/in
elif [ $ENV = c1m ]
then
SERVER_NAME=ampfproddb3
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/AMPF-CRM-R2/tableinfo/in
elif [ $ENV = ampdb ]
then
SERVER_NAME=ampfproddb1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=ampdb-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/EAR/tableinfo/in
elif [ $ENV = crmperf ]
then
SERVER_NAME=ampfdrdb2
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/AMPF_PERF1/tableinfo/in
elif [ $ENV = aac ]
then
SERVER_NAME=aacproddb1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=aac-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/AMPF-AAC/tableinfo/in
elif [ $ENV = eval ]
then
SERVER_NAME=axd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=eval-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/EVAL60/tableinfo/in
elif [ $ENV = somytestorg ]
then
SERVER_NAME=axd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=somytestorg-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/SOmytestorg/tableinfo/in
elif [ $ENV = ihc ]
then
SERVER_NAME=axd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=ihc-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/IHC/tableinfo/in
elif [ $ENV = cps ]
then
SERVER_NAME=axd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=cps-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/CPS/tableinfo/in
elif [ $ENV = pprodnew ]
then
SERVER_NAME=axd8
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=pprodnew-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/PPRODNEW/tableinfo/in
elif [ $ENV = u6for ]
then
SERVER_NAME=axd4
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=u6for-RecCount-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/U6FOR/tableinfo/in
fi

cd ${LOG_DIR}

scp root@${SERVER_NAME}:${SERVER_ENV_SOURCE_PATH}/${FNAME} . >> ${LOG_DIR}/${ENV}_status-${DTF}.txt 2>> ${LOG_DIR}/${ENV}_err-${DTF}.txt
retcode=$?
if [ $retcode -eq 0 ]
then
        echo "${FNAME} file copied from ${SERVER_NAME} to sxa7" >> ${LOG_DIR}/${ENV}_status-${DTF}.txt 2>> ${LOG_DIR}/${env}_err-${DTF}.txt

else
        echo "${FNAME} file failed to copy from ${SERVER_NAME} to sxa7" >> ${LOG_DIR}/${ENV}_status-${DTF}.txt 2>> ${LOG_DIR}/${ENV}_err-${DTF}.txt
fi

cp -v ${FNAME} ${SERVER_ENV_TARGET_PATH} >> ${LOG_DIR}/${ENV}_status-${DTF}.txt 2>> ${LOG_DIR}/${ENV}_err-${DTF}.txt

ret=${?}

if [ ${ret} -eq 0 ]
then
        status="AVAILABLE"
        VAL=1
        log_func "${FNAME} file moved Successfully to ${SERVER_ENV_TARGET_PATH}"

else
        status="N/A"
        VAL=2
        log_func "${FNAME} file failed to move ${SERVER_ENV_TARGET_PATH}"
fi

COUNT=`expr $COUNT + 1`

echo ${COUNT},${u_ENV},${status} >> "/opt/smartoffice/instances/smnode1/bin/custom/db_record_count/csv/DB_RECORD_COUNT-${DTF}.csv"

mv ${LOG_DIR}/${FNAME} ${ARCHIVE_DIR}
ret=${?}

if [ ${ret} -eq 0 ]
then
        log_func "${FNAME} file moved Successfully to ${ARCHIVE_DIR}"

else
        log_func "${FNAME} file failed to move ${ARCHIVE_DIR}"
fi

if [ ${VAL} -eq 1 ]
then
        HTML_REP1
        log_func "HTML_REP1 function called."
else
        HTML_REP2
        log_func "HTML_REP2 function called."
fi

done

sendamail_func

echo "</table>" >>  /opt/smartoffice/instances/smnode1/bin/custom/db_record_count/html/DB_RECORD_COUNT_REPORT-${DTF}.html

