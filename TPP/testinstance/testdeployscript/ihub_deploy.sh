# this script is for deploy bundle on tpp ihub instance

#including conf file

source /opt/testinstance/testdeployscript/ihub_deploy.conf
declare -a deploy_files


#								 Function declarations



function initiate_build() {

# Extracting build


# storing jar files
cd $BLD_DIR
tmp_jar_files=$(ls *.jar)
build_jar_count=0
declare -a build_jar_file
for i in $tmp_jar_files
do
build_jar_files[build_jar_count++]=$i
done
echo "we found $build_jar_count jar files in the build, they are below"
echo ${build_jar_files[*]}
echo

# storing conf files
cd $BLD_DIR
tmp_conf_files=$(ls *.conf)
build_conf_count=0
declare -a build_conf_files

for i in $tmp_conf_files
do
build_conf_files[build_conf_count++]=$i
done
echo "we found $build_conf_count conf files in the build, ther are below"
echo ${build_conf_files[*]}


# Replacing new jar bundles with old

cd $BLD_DIR
tmp_jar_files=$(ls *.jar)
build_jar_count=0
confirm_value=0
declare -a build_jar_file
for i in $tmp_jar_files
do
build_jar_files[build_jar_count++]=$i
target_file=$(echo "$DEPLOY_WORK_DIR`echo $i | cut -d "-" -f1`"*)
source_file=$(echo "$BLD_DIR`echo $i | cut -d "-" -f1`"*)
if [ -f "$target_file" ]
then
{

echo "DELETING EXISTING BUNDLE "$target_file
echo
rm  $target_file
echo "INSERTING NEW BUNDLE "$target_file
echo
cp $source_file $target_file
if [ $? -eq 0 ] ; then
{
	confirm_value=1
}
fi

}
else
{

echo "INSERTING NEW BUNDLE"$target_file
echo
cp $source_file $target_file
if [ $? -eq 0 ] ; then
{
        confirm_value=1
}
fi



}
fi
done


if [ $confirm_value -eq 1 ] ; then
{

prepare_deploy

}
else
{

echo "There is problem with mingiling new jar bundles with existing "
echo "jar files under $BLD_DIR are not replaced or placed with the files under $DEPLOY_WORK_DIR"

}
fi

}




function prepare_deploy() {

deploy_files=$( ls $DEPLOY_WORK_DIR )
declare -a final_deploy_files
deploy_files_count=0

for i in $deploy_files
do

final_deploy_files[deploy_files_count++]=$i
done
echo "************************************************************"
copy_first_file
}



function copy_first_file() {

echo "COPYING tpp-services FILE"
for word in `cat tmp.txt` ; do echo $word > /opt/testinstance/work/tmp.txt; done
first_file=( `cat tmp.txt | grep "tpp-services"*` )
echo DEPLOYING FIRST FILE $first_file
cp $DEPLOY_WORK_DIR$first_file $DPLY_DIR
}



function backup_bundle() {
# BACKING UP THE EXISTING BUNDLES

if [ ! -d $DPLY_DIR ] ; then
{
        echo "THERE IS NO DEPLOY DIR ANYWAY  CREATING DEPLOY DIR"
	mkdir $DPLY_DIR
	
}	
fi

echo "BACKING UP CURRENT BUNDLES"
if [ ! -d $WORK_DIR ] ; then
{
        echo "CREATING WORK DIR"
        mkdir $WORK_DIR

}
fi

cp -r $DPLY_DIR $WORK_DIR
if [ $? -eq 0 ] ; then
{

	tar -czf "$BKP_DIR$BKP_FNAME.tar.gz" $DPLY_DIR.
	if [ $? -eq 0 ] ; then
	{
		safevar="$DPLY_DIR*"
		rm -rf $safevar
		echo "DONE"
		
	}
	else
	{
        echo "BACKUP FAILED WHILE  TARRING "
        echo "DISCK FULL MAY THE POSSIBLE REASONS, PLEASE CHECK"
        echo "TERMINATING DEPLOYMENT TO PREVENT DATA LOSE"
        exit

	}
	fi
}
else
{
	echo "BACKUP FAILED WHILE  COPYING TO THE WORK DIRECTORY"
	echo "DISCK FULL MAY THE POSSIBLE REASONS, PLEASE CHECK"
	echo "TERMINATING DEPLOYMENT TO PREVENT DATA LOSE"
	exit

}
fi

# removing data dir
 if [ -d $DATA_DIR ] 
then
{

	rm -rf $DATA_DIR

}

else
{
	echo $DATA_DIR "NOT FOUND TO DELETE"
}

fi
			
}





# Calling required functions
backup_bundle
initiate_build
