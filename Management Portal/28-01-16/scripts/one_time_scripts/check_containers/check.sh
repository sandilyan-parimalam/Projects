#Author:Sandy ,HSG, mytestorg.
#Decription:this script to modify text/conf file on containers

#if [  -f update_conf.conf ]  ; then
#
#	source update_conf.conf
#	if [ -z "$containers" ] || [ -z $conf_file_path  ] || [ -z $conf_file_name ] ; then
#
#		echo "some of the varriables are not set prperly, please check and re-run me"
#		exit
#
#	fi
#
#
#else
#	echo "unable to locate conf file, please check"
#	exit
#fi





function check_apache () {

CID=$1

is_running=`vzctl exec $CID 'ps -aef | grep apache | grep -v "grep"'`

if [ ! -z "$is_running" ] ; then

	is_listening=`vzctl exec $CID 'netstat -anp | grep -E "LISTEN|ESTABLISHED" | grep http'`
	if [ ! -z "$is_listening" ] ; then

		echo "APACHE SERVICE=UP"
                echo "APACHE PORT=UP"


	else

                echo "APACHE SERVICE=UP"
                echo "APACHE PORT=DOWN"


	
	fi

else

                echo "APACHE SERVICE=DOWN"


fi
}




function check_tomcat () {

CID=$1

is_live_running=`vzctl exec $CID 'ps -aef | grep "/tomcat/bin/" | grep -v "grep"'`
is_test_running=`vzctl exec $CID 'ps -aef | grep "/tomcat_test/bin/" | grep -v "grep"'`


if [ ! -z "$is_live_running" ] ; then


		echo "LIVE TOMCAT=UP"
        else

                echo "LIVE TOMCAT=DOWN"

fi


if [ ! -z "$is_test_running" ] ; then

                echo "TEST TOMCAT=UP"

        else

                echo "TEST TOMCAT=DOWN"


        fi


}


















containers=`vzlist -a | grep running | sed 's# ##g' | cut -c1-3`
for i in $containers
do
echo "_____________________________"
echo "checking container ID $i"
check_tomcat $i
check_apache $i
echo "_____________________________"
echo ""
echo ""
echo ""


done
