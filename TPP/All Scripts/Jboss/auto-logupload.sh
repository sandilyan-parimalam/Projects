
DTF="$(date '+%F')"
echo "Starting time" >> /opt/jbossAS/scripts/log/time-$DTF.log
date >> /opt/jbossAS/scripts/log/time-$DTF.log
hn="$(hostname)"
tpp_log=/opt/jbossAS/jboss-4.2.3.GA/bin/logs
LOCATION=/logs/upload/
cd $tpp_log
if [ $? -eq 0 ]; then
find . -mtime 0 | cpio -ov --format=ustar > tpp-$hn-$DTF.tgz
echo "Log compression completing time" >> /opt/jbossAS/scripts/log/time-$DTF.log
date >> /opt/jbossAS/scripts/log/time-$DTF.log
echo "Ftp upload starting" >> /opt/jbossAS/scripts/log/time-$DTF.log
date >> /opt/jbossAS/scripts/log/time-$DTF.log
#tar -zcvf tpp-$hn-$DTF.tgz $log_file1 $log_file2 $log_file3 $log_file4
############### F T  P ##############
                SNAME=ftp.planetsoft.com
                UNAME=psmetlife
                PASSWORD="Bidb9yu@03"
                LLOCATION=logs/upload/
#cd $logpath
ftp -inv $SNAME << EOF
user $UNAME $PASSWORD
cd  $LLOCATION
mkdir ${DTF}
cd ${DTF}
bin
put tpp-$hn-$DTF.tgz
close
bye
EOF
echo "Ftp upload Completing" >> /opt/jbossAS/scripts/log/time-$DTF.log
date >> /opt/jbossAS/scripts/log/time-$DTF.log
rm tpp-$hn-$DTF.tgz

echo "TPP Log Uploaded to FTP ftp://psmetlife:"Bidb9yu@03"@ftp.planetsoft.com$LLOCATION/${DTF}/tpp-"$hn"-"$DTF".tgz" | mail -s "LOG Upload-$DTF" tpphsg@mytestorg.com,Jaideep.Mukarjee@mytestorg.com,praveen.chakinala@rackspace.mytestorg.com mlleads@mytestorg.com 

else 
echo "Change Directory Failed to $tpp_log"
fi
echo "Log Upload completed"  >> /opt/jbossAS/scripts/log/time-$DTF.log
date >> /opt/jbossAS/scripts/log/time-$DTF.log
