#!/bin/bash
#LOG UPLOAD SCRIPT
#set -x
hn="$(hostname)"
DTF="$(date '+%F')"
DTHM="$(date '+%F-%H-%M')"
IID=${1}
tpp_web_log=/opt/tppinstance/web/logs/
tpp_app_log=/opt/jbossAS/jboss-4.2.3.GA/bin/logs/
tpp_ihub_log=/opt/tppihub/iHub/app/data/log/

> tpp_list

for i in tpp_web_log tpp_app_log tpp_ihub_log;do
echo $i >> tpp_list
done

while [ "$IID" == "" ]; do
                PS3='Type a number: '
                echo Choose LOG type to upload:
                select IID in $(cat tpp_list); do
                        if [ $IID ]; then
                                break;
                        else
                                echo Invalid selection.
                        fi
                done
        done


if [ "$IID" = "tpp_web_log" ]; then

if [ -d $tpp_web_log ];then
cd $tpp_web_log
tar -zcvf $IID.tgz *.log*
mv $IID.tgz /tmp/
else
echo "$tpp_web_log directory doesn't exist"
exit;
fi

elif [ "$IID" = "tpp_ihub_log" ]; then

if [ -d $tpp_ihub_log ];then
cd $tpp_ihub_log
tar -zcvf $IID.tgz *.log*
mv $IID.tgz /tmp/
else
echo "$tpp_ihub_log directory doesn't exist"
exit;
fi

elif [ "$IID" = "tpp_app_log" ]; then

if [ -d $tpp_app_log ];then
cd $tpp_app_log
tar -zcvf $IID.tgz *.log*
#find -type f -iname  "*.log*" -mtime -1 -exec tar -zcvf $IID.tgz {} \; #### not working
mv $IID.tgz /tmp/
else
echo "$tpp_app_log directory doesn't exist"
exit;
fi

else
echo "Please Verife and Select the option."
                exit 1

fi

cd /tmp/
mv $IID.tgz "$hn"_"$IID"_"$DTHM".tgz
############### F T  P ##############
                SNAME=ftp.planetsoft.com
                UNAME=psmetlife
                PASSWORD="Bidb9yu@03"
                LLOCATION=logs/upload/
#cd $logpath
if [ -f "$hn"_"$IID"_"$DTHM".tgz ];
then
ftp -pinv $SNAME <<End-Of-Session
user $UNAME $PASSWORD
cd  $LLOCATION
mkdir ${DTF}
cd ${DTF}
mkdir ${IID}
cd ${IID}
binary
put "$hn"_"$IID"_"$DTHM".tgz
bye
End-Of-Session
echo "Logs uploaded to FTP ftp://ftp.planetsoft.com/"$LLOCATION""${DTF}"/${IID}/"$hn"_"$IID"_"$DTHM".tgz"
rm /tmp/"$hn"_"$IID"_"$DTHM".tgz
else
echo "File "$hn"_"$IID"_"$DTHM".tgz doesn't exist"
fi
