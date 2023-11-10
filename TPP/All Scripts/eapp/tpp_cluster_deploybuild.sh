#!/bin/bash
#Deploy TPP build
scriptpath=/opt/jbossAS/scripts
source $scriptpath/tppenv.conf
depdate=$(date '+%F')
instance=$1
if [ -z "$instance" ]; then
        COLUMNS=1
        PS3='Input a number: '
        echo
        echo Choose which instance for deployment:
        select instance in $(ls /opt/jbossAS/tppinstance | grep "tpp*"); do
                if [ $instance ]; then
                        break;
                else
                        echo Invalid selection.
                fi
        done
fi

if [ ! -d $build_home ];
then
mkdir -p /opt/jbossAS/builds
fi
if [ ! -d $backup_home ];
then
mkdir -p /opt/jbossAS/backup
fi 

function ftpdownload()
{
############### F T  P ##############
echo "Enter the ftp path to download the build:"
read a
echo "Enter the EAR file name to be deployed:"
read b
LLOCATION=$a
FNAME=$b

mkdir $build_home/$depdate
cd $build_home/$depdate
if [ -f $b ];
then
echo "Removing existing $b file..."
rm $b
fi

if [ -d "$app_home/$instance" ];
then
ftp -pinv $SNAME <<End-Of-Session
user $UNAME $PASSWORD
cd  $LLOCATION
binary
get $b
bye
End-Of-Session
else
echo "$instance doesn't exist"
fi
}
function jstop()
{
service jboss-$instance stop
}
function jstart()
{
service jboss-$instance start
}

ftpdownload

echo "Stopping the Instance node01 `hostname` $instance......"
jstop
echo "Deploying $b file to node01 `hostname`  $instance......."
if [ -f $build_home/$depdate/$b ];
then
echo "Taking Backup for existing $b file.."
mkdir -p $backup_home/$depdate
mv $app_home/$instance/deploy/$b $backup_home/$depdate
echo "$app_home/$instance/deploy/$b has been moved to $backup_home/$depdate"
cp $build_home/$depdate/$b $app_home/$instance/deploy/
chown jboss:jboss $app_home/$instance/deploy/$b
else
echo "$build_home/$depdate/$b doesn't exists"
echo "Please Verify if the $b is download to correct path"
fi
echo "Starting the Instance $instance........"
jstart
sleep 10s
echo "Stopping the Instance node02 `ssh uatnode2 hostname` $instance...."
ssh uatnode2 service jboss-$instance stop
scp $app_home/$instance/deploy/$b uatnode2@$app_home/$instance/deploy/
ssh uatnode2 chown jboss:jboss $app_home/$instance/deploy/$b
echo "Starting the Instance node02 $instance....."
ssh uatnode2 service jboss-$instance start
echo "Deployment completed Successfully for $instance"
exit 1;
