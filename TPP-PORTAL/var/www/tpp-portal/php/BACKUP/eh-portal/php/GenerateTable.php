<?php
$server_name=$_GET['srv']; 
$output = shell_exec("/opt/scripts/eh_portal_scripts/bin/GenerateLinInfo.sh $server_name");
echo "$output";
?>

