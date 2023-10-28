#################################################################THIS IS FOR EXCEPTIONAL ENVIRaNMENTS FORMATS###################################
if [ ${ENV} == singapor ]
then
TARGET_PATH="/opt/smartoffice/instances/smnode1/smweb/files/SINGAPORE/tableinfo/in/"
elif [ ${ENV} == pplus ]
then
TARGET_PATH="/opt/smartoffice/instances/smnode1/smweb/files/SOPREMIER/tableinfo/in/"
elif [ ${ENV} == ffg ]
then
TARGET_PATH="/opt/smartoffice/instances/smnode1/smweb/files/FFG_PROD/tableinfo/in/"
elif [ ${ENV} == mfin ]
then
TARGET_PATH="/opt/smartoffice/instances/smnode1/smweb/files/MFINANCIAL/tableinfo/in/"
elif [ ${ENV} == kofcdr ]
then
TARGET_PATH="/opt/smartoffice/instances/smnode1/smweb/files/KOFC_DR/tableinfo/in/"
elif [ ${ENV} == myso4dr ]
then
TARGET_PATH="/opt/smartoffice/instances/smnode1/smweb/files/MYSO4_DR/tableinfo/in/"
elif [ ${ENV} == mfindr ]
then
TARGET_PATH="/opt/smartoffice/instances/smnode1/smweb/files/MFIN_DR/tableinfo/in/"
FNAME=mfinsp-RecCount-${DTF}.log
elif [ ${ENV} == penndr ]
then
TARGET_PATH="/opt/smartoffice/instances/smnode1/smweb/files/PENNDR/tableinfo/in/"
elif [ ${ENV} == smonitor ]
then
TARGET_PATH="/opt/smartoffice/instances/smnode1/smweb/files/SMARTMONITOR/tableinfo/in/"
elif [ ${ENV} == canada ] || [ ${ENV} == canada2 ] || [ ${ENV} == its ]
then
SOURCE_PATH="/opt/oracle/scripts/report/"
elif [ ${ENV} == cibc ] || [ ${ENV} == sx ]
then
SOURCE_PATH="/opt/oracle/scripts/utility-scripts/report/"
elif [ ${ENV} == cm ]
then
SOURCE_PATH="/SmartMonitor/SOOLogs/AMPFPRODWEB/DB_Record/"
TARGET_PATH="/opt/smartoffice/instances/smnode1/smweb/files/CMPROD/tableinfo/in/"
fi

