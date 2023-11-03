#Sandy
#this script will apply patch


#Temp vars
base_dir="/opt/tppihub/scripts/deploy_script"

function pre_check() {

if [ ! -z "$base_dir" ] ; then

	if [ -d "$base_dir" ] ; then
	
	if [ -f "$base_dir/tppenv.conf" ] ; then

		
		source tppenv.conf
		if [ "$app_home" ] || [ "$rpatch_home" ] || [ "$SNAME" ] || [ "$UNAME" ] || [ "$PASSWORD" ] ; then
		
			if [ -d "$app_home" ] ; then instance_base_dir=$app_home ; else echo -e "\033[31m Invalid app_home configured in tppenv.conf, Please change it..\033[0m"; exit;fi
                        if [ ! -d "$rpatch_home" ] ; then echo "Creating reverse patch home $rpatch_home" ; mkdir $rpatch_home ;fi
			temp_dir=/tmp/donot_delete_patching_going_on
			ftp_log="$temp_dir/ftp.log"
                        if [ ! -d "$temp_dir" ] ; then mkdir $temp_dir ; else rm -rf $temp_dir;mkdir $temp_dir ;fi

		else
			echo -e "\033[31m some of the below varriable is empty in tppenv.con,Please fill them \033[0m"
			echo "
				app_home
				rpatch_home
				SNAME	
				UNAME
				PASSWORD
				"
		fi
	else

		echo "Unble to find the tppenv.conf under $base_dir , please verify whether the base_dir varriable configured correctly in script, if yes then place/configure the file"
		exit

	fi	
	
	else

		echo -e "\033[31m INVALID base_dir which is unavailable..Please set script location as base path in the script. common path is /opt/jbossAS/scripts \033[0m"
		exit

	fi

else

	echo -e "\033[31m base_dir varriable is not set in script, please set it properly and run again \033[0m"
	exit

fi
}


function get_patch_info() {

if [ ! -d "$instance_base_dir/$instance/app/deploy" ] ; then

echo "Please select the instance"
PS3="Enter the instance number "
select instance in $( ls $instance_base_dir | grep -i iHub | egrep -v "bk|backup|_|old|new|bkp|don|use" )
do

if [ ! -d "$instance_base_dir/$instance/app/deploy" ] ; then

	echo -e  "\033[31m selected instance is NOT VALID, please select correct one \033[0m"
	echo -e "\033[31m if you are unable to see the correct instance, contact sysadmin \033[0m"
	exit

else
	instance_home="$instance_base_dir/$instance"

fi



read -p "Enter the FTP Path of the patch " ftp_path
if [ -z "$ftp_path" ] ; then
	echo -e "\033[31m Empty FTP path..... \033[0m"
	exit
fi

read -p "Enter the patch file name " patch_name
if [ -z "$patch_name" ] ; then
        echo -e "\033[31m Empty patch name..... \033[0m"
        exit
else
	if [ ! `echo $patch_name | grep "zip"` ] ; then
		echo -e "\033[31m \n invalid patch.....Patch should be zip file like below \033[0m"
		echo -e "\033[31m patch_envname_date_patch-count-of-the-day.zip \033[0m"
		exit
	else
		if [ -f "$rpatch_home/rev_${patch_name}" ] ; then
			echo -e "\033[31m Seems this path already applied, make sure you named the patch with correct patch count of the day \033[0m"
	                echo -e "\033[31m example: patch_envname_date_patch-count-of-the-day.zip \033[0m"
			echo -e "\033[31m if it was failed to apply , please remove it and run me again. file name is below.. \033[0m"
			echo -e "\033[31m $rpatch_home/rev_${patch_name} \033[0m"
			exit
		fi
	fi
fi
break
done

else
        instance_home="$instance_base_dir/$instance"

read -p "Enter the FTP Path of the patch " ftp_path
if [ -z "$ftp_path" ] ; then
        echo -e "\033[31m Empty FTP path..... \033[0m"
        exit
fi

read -p "Enter the patch file name " patch_name
if [ -z "$patch_name" ] ; then
        echo -e "\033[31m Empty patch name..... \033[0m"
        exit
else
        if [ ! `echo $patch_name | grep "zip"` ] ; then
                echo -e "\033[31m \n invalid patch.....Patch should be zip file like below \033[0m"
                echo -e "\033[31m patch_envname_date_patch-count-of-the-day.zip \033[0m"
                exit
        else
                if [ -f "$rpatch_home/rev_${patch_name}" ] ; then
                        echo -e "\033[31m Seems this path already applied, make sure you named the patch with correct patch count of the day \033[0m"
                        echo -e "\033[31m example: patch_envname_date_patch-count-of-the-day.zip \033[0m"
                        echo -e "\033[31m if it was failed to apply , please remove it and run me again. file name is below.. \033[0m"
                        echo -e "\033[31m $rpatch_home/rev_${patch_name} \033[0m"
                        exit
                fi
        fi
fi


fi
}


function download_patch() {

echo "Downloading Patch, Please wait..........."
cd $temp_dir
ftp -pinv $SNAME <<End-Of-Session > $ftp_log
user $UNAME $PASSWORD
cd  "$ftp_path"
binary
get "$patch_name"
bye
End-Of-Session


	if [ -f "$temp_dir/$patch_name" ] ; then
		echo "Patch downloaded successfully..."
	else
		if [ "`cat $ftp_log | grep -i "Not connected"`" ] ; then
			echo -e "\033[31m Unable to connect FTP Server, please check ftp servername or ipaddress in tppenv.conf and check the FTP is UP \033[0m"
			exit
		elif [ "`cat $ftp_log | grep -i "Login failed"`" ] ; then
                        echo -e "\033[31m Unable to login with the credentials stored in tppenv.conf, please check  the username/password or it may be changed/locked \033[0m"
			exit
                elif [ "`cat $ftp_log | grep -i "Failed to change directory"`" ] ; then
			echo -e "\033[31m Given FTP Path $ftp_path is not exist on FTP, please check and provide valid case sensitive path \033[0m"
			exit
                elif [ "`cat $ftp_log | grep -i "Failed to open file"`" ] ; then
			echo -e "\033[31m Given Patch file name $patch_name is not exist on FTP, please check and provide valid case sensitive patch name.... \033[0m"
			exit
		else
			echo -e "\033[31m Somehow unable to download the patch, please check the drive space and other reasons.. Below Is the ftp log \033[0m"
			cat $ftp_log
			exit
		fi
			
		
		
		
	fi


}




function backup() {

echo "Creating reverse patch..please wait"
cd $temp_dir
unzip -l $patch_name | sed '1,3d' | sed '$d' | sed '$d' | awk '{print $4}' | grep -v '/$' > patch_files.txt

if [ ! -z "patch_files.txt" ] ; then
	cd $instance_home
	zip "$rpatch_home/rev_${patch_name}" -@ < $temp_dir/patch_files.txt	
	if [ $? -eq 0 ] ; then
	
		echo -e "\033[32;1m Backup / Reverse patch created successfully with available files.... \033[0m"	
		echo -e "\033[32;1m revrese patch name is $rpatch_home/rev_${patch_name} \n \033[0m"
       elif [ $? -eq 1 ] ; then
		if [ -f "$rpatch_home/rev_${patch_name}" ] ; then
			echo -e "\033[32;1m Backup / Reverse patch create with warnin,some of the files in patch are new and they are skipped to include in reverse patch \033[0m"
                        echo -e "\033[32;1m revrese patch name is $rpatch_home/rev_${patch_name} \n \033[0m"

		else
			echo -e "\033[31m reverse patch file not created becuase the patch contains only new files... \033[0m"

		fi
	
	else

		echo -e "\033[31m unable to reverse patch or backup the existing files. zip command failed, please check.."
		exit
	fi

else

	echo -e "\033[31m Give patch is empty, Please provide a valid patch"
	exit

fi




}


function apply_patch() {
echo "applying patch, Please wait...."
cd $temp_dir
unzip -o $patch_name -d "$instance_home"
if [ $? -eq 0 ] ; then
                echo -e "\033[32;1m \n Done...\n"
                echo -e "\033[32;1m Patch applied successfully, Please start or restart the application if needed...."
                exit

else

        echo -e "\033[31m Unable to apply patch file, somehow unzip command failed, please validated the above output/error command output and act accordingly.."
        echo -r "\033[31m Please use the backup $rpatch_home/revrese_$patch_name if needed ...."
        exit
fi


}

pre_check
instance=$1
get_patch_info
download_patch
backup
apply_patch
