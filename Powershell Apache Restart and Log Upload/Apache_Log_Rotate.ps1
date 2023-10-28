#Author: Sandy,HSG
#Email:sandilyan.parimalam@mytestorg.com
#About Script: This script will stop apache and Move the logs to backup location then starts the apache back.

$Today=(Get-Date -Format yyyy-MM-dd)
$LogDir="C:\Apache2\logs"
$BackupDir="${LogDir}\Backup\${Today}"
$ApacheServiceName="Apache2.2.31"

$ftp = "ftp://216.3.117.138/sandy/test/${Today}"
$user = "india"
$pass= "transfer1"



function New-ArchiveFromFile

{

    [CmdletBinding()]

    [OutputType([int])]

    Param

    (

        # Param1 help description

        [Parameter(Mandatory=$true,

                   ValueFromPipelineByPropertyName=$false,

                   Position=0)]

        [string]

        $Source,

        # Param2 help description

        [Parameter(Mandatory=$true,

                   ValueFromPipelineByPropertyName=$false,

                   Position=1)]

        [string]

        $Destination

    )

    Begin

    {

        [System.Reflection.Assembly]::LoadWithPartialName(“System.IO.Compression.FileSystem”) | Out-Null

    }

    Process

    {

        try

        {

            Write-Verbose “Creating archive $Destination….”

            $zipEntry = “$Source“ | Split-Path -Leaf

            $zipFile = [System.IO.Compression.ZipFile]::Open($Destination, ‘Update’)

            $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal

            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zipfile,$Source,$zipEntry,$compressionLevel)

            Write-Verbose “Created archive $destination.”

        }

        catch [System.IO.DirectoryNotFoundException]

        {

            Write-Host “ERROR: The source $source does not exist!” -ForegroundColor Red

        }

        catch [System.IO.IOException]

        {

            Write-Host “ERROR: The file $Source is in use or $destination already exists!” -ForegroundColor Red

        }

        catch [System.UnauthorizedAccessException]

        {

            Write-Host “ERROR: You are not authorized to access the source or destination” -ForegroundColor Red

        }

    }

    End

    {

        $zipFile.Dispose()

    }

} 

function LogRotate {

if( (${LogDir}) -And (${BackupDir}) -And (${Today}) -And (${ApacheServiceName}) ) {

	$ServiceStatus=(Get-Service -Name ${ApacheServiceName} | select Status | FT -hide | Out-String | foreach { $_ -replace "`r|`n","" }|foreach {$_.Trim()})
	echo "Service status is $ServiceStatus"
	if (${ServiceStatus} -eq "Running"){

		echo "`nStopping Service ${ApacheServiceName}"

		Stop-Service -Name ${ApacheServiceName}

		$ServiceStatus=(Get-Service -Name ${ApacheServiceName} | select Status | FT -hide | Out-String | foreach { $_ -replace "`r|`n","" }|foreach {$_.Trim()})
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
			mkdir ${BackupDir} | Out-Null
		}
		$Logs=(ls ${LogDir} -Filter *.log)
		if(${Logs}) {
			echo "`nZipping Logs and Storing under Backup Folder`n"
			Get-ChildItem ${LogDir} -Filter *.log | ForEach-Object {
			$File=$_.FullName
			$FileName=$_.Name
			#Move -v $File ${BackupDir}/${Today}_${FileName}
			Add-Type -Assembly System.IO.Compression.FileSystem
			echo "`n<-----------------------------------------------------"
			echo "Working on ${FileName}"
			$ZipFileName="${BackupDir}\${FileName}_${Today}.zip"
			New-ArchiveFromFile -Source $File -Destination $ZipFileName
			echo "Removing ${File}"
			echo "----------------------------------------------------->"
			Remove-Item $File -Force


			}
			echo "`nZipping and Moving Completed`n"
			echo "Starting Service ${ApacheServiceName}"
			Start-Service -Name ${ApacheServiceName}
			$ServiceStatus=(Get-Service -Name ${ApacheServiceName} | select Status | FT -hide | Out-String | foreach { $_ -replace "`r|`n","" }|foreach {$_.Trim()})
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

}

function Upload{

	$ftp="${ftp}/"
	$UploadExclude=@('*error*','*http*','*access*')
	echo "`nCreating Folder on FTP"
	$makeDirectory = [System.Net.WebRequest]::Create($ftp);
	$makeDirectory.Credentials = New-Object System.Net.NetworkCredential($user,$pass);
	$makeDirectory.Method = [System.Net.WebRequestMethods+FTP]::MakeDirectory;
	$makeDirectory.GetResponse();
	echo "`nFolder Created Successfully"

	$webclient = New-Object System.Net.WebClient 
	$webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass)  
	foreach($item in (Get-ChildItem -Recurse $BackupDir "*.zip" -Exclude $UploadExclude )){ 
	    "Uploading $item..." 
	    $uri = New-Object System.Uri($ftp+$item.Name) 
	    $webclient.UploadFile($uri, $item.FullName) 
	 }



}
LogRotate 
Upload