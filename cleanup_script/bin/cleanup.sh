#!/bin/bash
#Author=sandy HSG
#Description=portable cleanup script

base_dir="/scripts/cleanup_script/bin"

# conf check
if [ -f $base_dir/cleanup.conf ]
then
source $base_dir/cleanup.conf
else
echo "configuration file is missing, please check,terminating the script..."
exit
fi

#name duplication check
count1=`echo $cleanup_names | wc -w`
count2=`echo $cleanup_names | sed 's# #\n#g' | sort | uniq | wc -w`

if [ $count1 -ne $count2 ]
then
echo "Duplicate cleanup names found, please validate the conf file..terminating script......"
exit
fi


#Preparing report mail
 echo "<HTML><BODY>" > $report_mail



for i in `echo $cleanup_names`
do
path=$(eval 'echo $'${i}_path)
age=$(eval 'echo $'${i}_cleanup_age)
patern=$(eval 'echo $'${i}_files_patern)


echo "checking $i configuration.........."
echo "<BR>" >> $report_mail
echo "<TABLE BORDER=1>" >> $report_mail
echo "<TR><TH COLSPAN=2> $i </TH></TR>" >> $report_mail
if [ ! -z "$path" ] ; then

        if [ -d "$path" ] ; then

                if [ ! -z "$age" ] ; then

                        if [[ $age != *[[:alpha:]]* ]] ; then

                                if [ ! -z "$patern" ] ; then

                                        echo clean up in progress for $i
                                        cd $path
                                                for ptn in `echo $patern`
                                                do
							cleanable_files=`find . -name "*.$ptn" -type f -mtime "+$age"`
							if [ ! -z "$cleanable_files" ] ; then
								echo "<TR>" >> $report_mail
								echo "cleanable files for $i with ( $ptn ) are below"
								for x in $cleanable_files ; do echo $x | sed 's#./##g' >> $report_mail; echo "</BR>" >> $report_mail ; done
								echo "</TR>" >> $report_mail
								echo "$cleanable_files"
								echo "***********CLEANING UP **************"
								find . -name "*.$ptn" -type f -mtime +$age | xargs rm -f
								echo "**********CLEANED UP!!!!!!!************************"

							else
								echo " there is no cleanble file for $i with ( $ptn ) patern"
								echo "<TR><TD> NO CLEANBLE FILES IN  ( $ptn ) EXTENSION </TD></TR>"  >> $report_mail
							fi
	                                       done
                                else
                                        echo "patern is missing for cleanup $i , cleanup aborting for $i ......"
					echo "<TR><TD BGCOLOR="red">FILE EXTENSION IS MISSING ON CONF FILE,PLEASE CHECK</TD></TR>" >> $report_mail
                                fi
                        else
                                echo "provided age is not valid, please check the conf file .......cleanup aborting for $i "
				echo "<TR><TD BGCOLOR="red">INVALID CLEANUP AGE ($age) FOUND ON CONF FILE,PLEASE CHECK</TD></TR>" >> $report_mail
                        fi
                else
                        echo "Age is not provided for cleanup $i , cleanup aborting for $i ...."
			echo "<TR><TD BGCOLOR="red">CLEANUP AGE IS MISSING ,PLEASE CHECK CONF FILE</TD></TR>" >> $report_mail
                fi
        else
                echo "provided path ( $path ) not found......cleanup aborting for $i "
		echo "<TR><TD BGCOLOR="red"> CONFIGURED PATH NOT EXIST ON SERVER, PLEASE CHECK </TD></TR>" >> $report_mail
        fi
else
        echo "Path not provided for cleanup $1 , cleanup aborting for $1 ......"
	echo "<TR><TD BGCOLOR="red">CLEANUP PATH IS MISSING ,PLEASE CHECK CONF FILE</TD></TR>" >> $report_mail
fi
echo "</TABLE>" >> $report_mail
done

echo "</BODY></HTML>" >> $report_mail
mutt -e 'set content_type=text/html' -s "$SUBJECT" $TO < $report_mail

