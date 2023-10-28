#Author: Sandy,HSG
#Email:sandilyan.parimalam@mytestorg.com
#About Script: This script will stop apache and Move the logs to backup location then starts the apache back.

$LogDir="C:\Users\sparimalam\Desktop\All\tmp"
$BackupDir="${LogDir}\Backup"
$Today=Get-Date -format d_M_y
$ApacheServiceName="TeamViewer" #This should be replaced Replaced with Apache service name [ For temporary purpose , i am using TeamViewe Service] 

if( (${LogDir}) -And (${BackupDir}) -And (${Today}) -And (${ApacheServiceName}) ) {

	$ServiceStatus=(Get-Service -Name ${ApacheServiceName} | select Status | FT -hide | Out-String | foreach { $_ -replace "`r|`n","" })
	echo "Service status is $ServiceStatus"
	if (${ServiceStatus} -eq "Running"){

		echo "`nStopping Service ${ApacheServiceName}"

		Stop-Service -Name ${ApacheServiceName}

		$ServiceStatus=(Get-Service -Name ${ApacheServiceName} | select Status | FT -hide | Out-String | foreach { $_ -replace "`r|`n","" })

		if (${ServiceStatus} -eq "Running"){
			echo "`nERR:Unable to Stop Service ${ApacheServiceName}`nPlease Fix this issue to run this script`n"
			exit

		}else{
			echo "`nService Stopped Successfully"
		}
			
	}else{
		echo "`n${ApacheServiceName} Already not running"
		}

	if (Test-Path ${LogDir}) {

		if (-Not (Test-Path ${BackupDir})) {
			echo "`nCreating Backup Folder ${BackupDir}"
			mkdir -p ${BackupDir} | Out-Null
		}

		$Logs=(ls ${LogDir} -Filter *.log)
		if(${Logs}) {
			echo "`nMoving Logs to Backup Folder`n"
			Get-ChildItem ${LogDir} -Filter *.log | ForEach-Object {
				$File=$_.FullName
				$FileName=$_.Name
				Move -v $File ${BackupDir}/${Today}_${FileName}

			}
			echo "Moving Completed`n"
			echo "Starting Service ${ApacheServiceName}"
			Start-Service -Name ${ApacheServiceName}
			$ServiceStatus=(Get-Service -Name ${ApacheServiceName} | select Status | FT -hide | Out-String | foreach { $_ -replace "`r|`n","" })
				if (${ServiceStatus} -eq "Running"){
					echo "`nService Started Successfully"
					
				}else{
					echo "ERR: Unable to start the service ${ApacheServiceName}, Please Fix it to resume services"
				}

			}else{

			echo "`nNo Log Files Exist Under ${LogDir}`n"
		}

	}else {

		echo "`n${LogDir} is not exist`n"

	}

}else {
	echo "`nEmpty variable Found`nCheck Varriables in the Script`nVariables: LogDir,BackupDir,Today,ApacheServiceName`n"
}