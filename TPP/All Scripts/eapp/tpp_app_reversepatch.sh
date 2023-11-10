#!/bin/bash
#Apply Patch to TPP environment

scriptpath=/opt/jbossAS/scripts
source $scriptpath/tppenv.conf
depdate=$(date '+%F')
instance=$1
if [ -z "$instance" ]; then
        COLUMNS=1
        PS3='Input a number: '
        echo
        echo Choose which instance for deployment:
        select instance in $(ls /opt/jbossAS/tppinstance | grep "^jh*" | grep -v jboss-modules.jar ); do
                if [ $instance ]; then
                        break;
                else
                        echo Invalid selection.
                fi
        done
fi


patchfile=$2

if [ -z "$patchfile" ]; then
        COLUMNS=1
        PS3='Input a number: '
        echo
        echo Choose the patch file for patching $instance:
        select patchfile in $(ls -tR  $rpatch_home | grep "zip"); do
                if [ $b ]; then
                        break;
                else
                        echo Invalid selection.
                fi
        done
fi
        if [ -z "$patchfile" ] ; then
        echo "there is no patch files found to revrese.."
        exit
        fi


function jstop()
{
service jboss-$instance stop
}
function jstart()
{
service jboss-$instance start
}

#ftpdownload
#echo "Stopping the Instance $instance......"
#jstop

echo "Applying $patchfile file to $instance......."
if [ -f $rpatch_home/$patchfile ];
then
echo "Taking Backup for existing $b file.."
cd  $rpatch_home
zipinfo --h-t $patchfile | egrep -v '^d' | awk '{print $9}' > $scriptpath/jname
bname=$(basename $patchfile .zip)
echo "Applying reverse patch $b to $instance"
cd   $app_home/$instance/tppconfig/ 
unzip -o $rpatch_home/$patchfile
for i in `cat $scriptpath/jname`;
do
cd $app_home/$instance/tppconfig/
echo "Changing owner to jboss for $i files"
chown -R jboss:jboss $i
done
echo "Patch Applied Successfully for $instance"
else
#echo "$patch_home/$depdate/$b doesn't exists"
echo "Please Verify if the patch $patchfile is avaible under  $rpatch_home"
fi
#echo "Starting the Instance $instance........"
#jstart
sleep 1s
echo
echo
echo "If this patch required restart, please restart the $instance e.g ( service jboss-$instance restart )"
rm $scriptpath/jname
exit 1;
