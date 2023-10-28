#Author:Sandy ,HSG, mytestorg.
#Decription:this script to modify text/conf file on containers

if [  -f update_conf.conf ]  ; then

	source update_conf.conf
	if [ -z "$containers" ] || [ -z $conf_file_path  ] || [ -z $conf_file_name ] ; then

		echo "some of the varriables are not set prperly, please check and re-run me"
		exit

	fi

else
	echo "unable to locate conf file, please check"
	exit
fi




for i in $containers
do

	if [ -d /vz/root/$i ] ; then

		if [ -f /vz/root/$i/$conf_file_path/$conf_file_name ] ; then

			cp /vz/root/$i/$conf_file_path/$conf_file_name /vz/root/$i/$conf_file_path/$conf_file_name-`date +%F`.bkp
			if [ $? -eq 0 ] ; then

				cat /vz/root/$i/$conf_file_path/$conf_file_name | grep '^SSLCipherSuite ALL:!aNULL:!ADH:!eNULL:!LOW:!EXP:RC4+RSA:+HIGH:+MEDIUM' > /dev/null 
				if [ $? -eq 0 ] ; then

					#sed -i 's/^SSLProtocol/#SSLProtocol/g' /vz/root/$i/$conf_file_path/$conf_file_name
					sed -i 's/EXP:RC4+RSA:+HIGH:+MEDIUM/EXP:RC4+RSA:+HIGH:+MEDI/' /vz/root/$i/$conf_file_path/$conf_file_name
						if [ $? -eq 0 ] ; then

							echo "conf file has been successfuly updated for CID $i"
							vzctl exec $i '/etc/init.d/apache stop'
								sleep 10
                                                        vzctl exec $i '/etc/init.d/apache start'


						
						else

							echo "error while inserting  SSLProtocol -ALL -SSLv2 -SSLv3 +TLSv1  , please check for $i"

						fi 
					

				else

					echo "SSLCipherSuite tag not found for $i "				

				fi			

			else

				echo "unable to backup conf file for $i, please check."
			

			fi	

		else

			echo "conf file path  $conf_file_path  or name  $conf_file_name  you mentioned not found for $i, please check and re-run"

		fi

	else

		echo " $i  which you mentioned as container id is not present or invalid, unable to locate, please check"

	fi

done
