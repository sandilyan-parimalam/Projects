<html>
<head>
<title> Lin Deployment Tracer </title>
<?php
session_start();
require('CheckSession.php');

?>
<style>

.op{
margin-left:300px;
margin-top:100px ;
background-color:rgba(255,255,255,0.6);
width:800px;
height:900px;
font-weight: 650;
font-size:16px;
font-family:Courier New;
}

</style>


</head>

<body background="/lin_administration/images/LinDepFormImage.jpg">
<form>
<div class=op>


<?php

$containerID=$_GET['cid'];
$instance=$_POST['SelectedTomcatInstance'];
$ftppath= $_POST['ftppath'];
$warname=$_POST['warname'];



                                header('Content-Encoding: none;');
                                set_time_limit(0);
                                $username=$_SESSION['login_user'];
                                $output = shell_exec("../shell/AppendLog.sh $username is deploying a WAR file , details - container ID : $containerID , tomcat name : $instance , FTP Path : $ftppath ,  WAR Name : $warname ");

                                $handle = popen("sudo vzctl exec $containerID '/opt/scripts/maintenance_scripts/bin/menu.sh linupdate $instance $ftppath $warname'", "r");

                                if (ob_get_level() == 0)
                                        ob_start();

                                        while(!feof($handle)) {
                                            $buffer = fgets($handle);
                                            $buffer = trim(htmlspecialchars($buffer));
                                            echo $buffer . "<br />";
                                            echo str_pad('', 4096);
                                            ob_flush();
                                            flush();
                                            sleep(1);
                                        }

                                pclose($handle);
                                ob_end_flush();


?>

<p align=center> <input type=submit value=close onclick="self.close()" /></p>

</div>
</form>
</body>
</html>
