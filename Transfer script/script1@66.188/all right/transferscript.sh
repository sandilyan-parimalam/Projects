#!/bin/bash
#Nagpur PMGMS build Transfer script
#Author=Sandilyan
clear
echo -e "\033[36m **************************************************  \033[0m"
echo -e "\033[36m WELCOME TO THE NAGPUR PMGMS TRANSFER SCRIPT \033[0m"
echo -e "\033[36m **************************************************  \033[0m"
echo""
FTP_HOST=ftp.ezdata.com
FTP_USER=ecprelease
FTP_PASSWD=ecprelease
$bno
while read -p "Please enter the build number " bno;
 do
   if [[ -z "${bno}" ]]; then   # Checkin for empty vallue
     echo ""
     echo -e "\033[31;1m That was empty, do it again! \033[0m "
   else
       if [ "$bno" -eq "$bno" ] 2>/dev/null; # checking for any STRING value
         then
             if [ $bno -lt 6400 ] || [ $bno -gt 10000 ] # Checking invalid digits of number(invalid build number for now
               then
                   echo ""
                   echo -e $bno "\033[31;1m is not a valid build number \033[0m"
               else
                   echo ""
                   echo -e "\033[32;1m   PROCESSING \033[0m"
                   break
             fi
        else
            echo ""
            echo -e $bno "\033[31;1m is not a valid build number \033[0m"
      fi
   fi
 done
echo""

echo -e "\033[32;1m CREATING DIRECTORY \033[0m"

  if test -d /opt/smartoffice/builds;
     then
        if test -d /opt/smartoffice/builds/build_$bno
          then
               echo ""

                echo -e "\033[31;1m DIRECTORY ALLREADY EXISTS \033[0m"
		echo ""
                echo -e "\033[31;1m DELETING OLD AND CREATING NEW ONE \033[0m"
		echo ""
		cd /opt/smartoffice/builds/
                rm -rf build_$bno
                mkdir build_$bno
               
                echo -e "\033[32;1m LOCAL DIRECTORY CREATED \033[0m"

          else
		cd /opt/smartoffice/builds/
                mkdir build_$bno
                echo ""
                echo -e "\033[32;1mLOCAL DIRECTORY CREATED \033[0m "
               
          fi
     else
        echo ""
        echo -e "\033[32;1m CREATING LOCAL DIRECTORY \033[0m"
               cd /opt/smartoffice/
               mkdir builds
               cd builds

               mkdir build_$bno
              
        echo ""
        echo -e "\033[32;1m LOCAL DIRECTORY CREATED \033[0m"
 fi
FTP_BUILD_PATH=/gen7.0.1/build_$bno/
HOST=172.16.2.19
USER=noc
PASS=nocchennai
cd /opt/smartoffice/builds/build_$bno/
wget ftp://$FTP_USER:$FTP_PASSWD@$FTP_HOST/${FTP_BUILD_PATH}/gen-ear-7.0.1-$bno.ear .
ftp -inv $HOST <<EOF
user $USER $PASS
cd gen7.0.1
mkdir build_$bno
cd build_$bno
bin
put gen-ear-7.0.1-$bno.ear 
bye





















