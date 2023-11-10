#!/bin/bash

set -x

source "/opt/smartoffice/instances/smnode1/bin/custom/maintenance_logs/conf/maintenance_logs.conf"

for ENV in ${HOSTS}
do

if [ $ENV = myso3 ]
then
SERVER_NAME=axd5
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/${u_ENV}/maintenancelog/in
elif [ $ENV = myso6 ]
then
SERVER_NAME=axd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/${u_ENV}/maintenancelog/in
elif [ $ENV = china ]
then
SERVER_NAME=axd1
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/SOCHINA/maintenancelog/in
elif [ $ENV = japan ]
then
SERVER_NAME=axd1
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/JAPAN/maintenancelog/in
elif [ $ENV = singapor ]
then
SERVER_NAME=axd1
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/SINGAPORE/maintenancelog/in
elif [ $ENV = pplus ]
then
SERVER_NAME=axd1
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/SOPREMIER/maintenancelog/in
elif [ $ENV = pplusuat ]
then
SERVER_NAME=pxd7
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/PPLUS_UAT/maintenancelog/in
elif [ $ENV = penn ]
then
SERVER_NAME=sxd9
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/${u_ENV}/maintenancelog/in
elif [ $ENV = mfin ]
then
SERVER_NAME=sxd9
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MFINANCIAL/maintenancelog/in
elif [ $ENV = myso4dr ]
then
SERVER_NAME=sxd9
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MYSO4_DR/maintenancelog/in
elif [ $ENV = kofcdr ]
then
SERVER_NAME=sxd9
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/KOFC_DR/maintenancelog/in
elif [ $ENV = myso4 ]
then
SERVER_NAME=axd9
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/${u_ENV}/maintenancelog/in
elif [ $ENV = kofc ]
then
SERVER_NAME=axd9
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/${u_ENV}/maintenancelog/in
elif [ $ENV = soindia ]
then
SERVER_NAME=cxa1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=soindia-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/opt/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/${u_ENV}/maintenancelog/in
elif [ $ENV = canada ]
then
SERVER_NAME=txd1
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/opt/oracle/scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/SOOCANADA/maintenancelog/in
elif [ $ENV = canada2 ]
then
SERVER_NAME=txd1
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/opt/oracle/scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/SOOCANADA2/maintenancelog/in
elif [ $ENV = ampfcrm ]
then
SERVER_NAME=ampfproddb4
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/AMPF-CRM-R2/maintenancelog/in
elif [ $ENV = ampdb ]
then
SERVER_NAME=ampfproddb1
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/EAR/maintenancelog/in
elif [ $ENV = mysodr ] || [ $ENV = myso2dr ] || [ $ENV = myso3dr ]
then
SERVER_NAME=sxd1
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/${u_ENV}/maintenancelog/in
elif [ $ENV = ampfaac ]
then
SERVER_NAME=aacproddb1
FNAME=aac-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/AMPF-AAC/maintenancelog/in
elif [ $ENV = ihc ]
then
SERVER_NAME=axd1
FNAME=ihc-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/IHC/maintenancelog/in
elif [ $ENV = ffg ]
then
SERVER_NAME=axd1
FNAME=ffg-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/FFG_PROD/maintenancelog/in
elif [ $ENV = cana2uat ]
then
SERVER_NAME=txd2
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/opt/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/SOOCANADA2_UAT/maintenancelog/in
elif [ $ENV = nfppprod ]
then
SERVER_NAME=sxd4
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/NFP_PREPROD/maintenancelog/in
elif [ $ENV = crmperf ]
then
SERVER_NAME=ampfdrdb2
FNAME=crmperf-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/AMPF_PERF1/maintenancelog/in
elif [ $ENV = fullsail ]
then
SERVER_NAME=pxd2
FNAME=fullsail-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/DXO_1_0/maintenancelog/in
elif [ $ENV = soits ]
then
SERVER_NAME=txd1
FNAME=its-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/opt/oracle/scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/SOITS/maintenancelog/in
elif [ $ENV = mysql ]
then
SERVER_NAME=pxw10
FNAME=MYSQL-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/backup/mysql/scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MYSQL/maintenancelog/in
elif [ $ENV = denver ]
then
SERVER_NAME=ampfproddb4
FNAME=ampfcrm-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility_scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/AMPF-CRM-R2_DR/maintenancelog/in
elif [ $ENV = mfindr ]
then
SERVER_NAME=pxd16
FNAME=mfinsp-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MFINANCIAL_DR/maintenancelog/in/
elif [ $ENV = jhfn ]
then
SERVER_NAME=axd1
FNAME=jhfn-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/JHFN/maintenancelog/in/
elif [ $ENV = hsbc ]
then
SERVER_NAME=axd1
FNAME=hsbc-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/HSBC/maintenancelog/in/
elif [ $ENV = eval ]
then
SERVER_NAME=axd1
FNAME=eval-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/EVAL60/maintenancelog/in
elif [ $ENV = myso ]
then
SERVER_NAME=axd5
FNAME=myso-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MYSO/maintenancelog/in
elif [ $ENV = myso2 ]
then
SERVER_NAME=axd5
FNAME=myso2-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MYSO2/maintenancelog/in
elif [ $ENV = somytestorg ]
then
SERVER_NAME=axd1
FNAME=somytestorg-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/SOmytestorg/maintenancelog/in
elif [ $ENV = tdbank ]
then
SERVER_NAME=axd1
FNAME=tdbank-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/TDBANK/maintenancelog/in
elif [ $ENV = cps ]
then
SERVER_NAME=axd1
FNAME=cps-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/CPS/maintenancelog/in
elif [ $ENV = smonitor ]
then
SERVER_NAME=axd4
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/SMARTMONITOR/maintenancelog/in
elif [ $ENV = myso5 ]
then
SERVER_NAME=axd4
u_ENV=`echo ${ENV} | tr a-z A-Z`
FNAME=${ENV}-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/MYSO5/maintenancelog/in
elif [ $ENV = pprodnew ]
then
SERVER_NAME=axd8
FNAME=pprodnew-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/PPRODNEW/maintenancelog/in
elif [ $ENV = u6for ]
then
SERVER_NAME=axd4
FNAME=u6for-maintlog-${DTF}.log
SERVER_ENV_SOURCE_PATH=/home/oracle/scripts/utility-scripts/report
SERVER_ENV_TARGET_PATH=/opt/smartoffice/instances/smnode1/smweb/files/U6FOR/maintenancelog/in
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

mv -v *${DTF}*.log ${ARCHIVE_DIR} >> ${LOG_DIR}/${ENV}_status-${DTF}.txt 2>> ${LOG_DIR}/${ENV}_err-${DTF}.txt

cd ${ARCHIVE_DIR}

zip ${FNAME}.zip ${FNAME} >> ${LOG_DIR}/${ENV}_status-${DTF}.txt 2>> ${LOG_DIR}/${ENV}_err-${DTF}.txt 

rm ${FNAME}  >> ${LOG_DIR}/${ENV}_status-${DTF}.txt 2>> ${LOG_DIR}/${ENV}_err-${DTF}.txt

done
