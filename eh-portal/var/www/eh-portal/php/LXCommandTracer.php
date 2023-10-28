<!-- 
Developed By:Sandy
Desc:This script will invoke the target scripts which are located on LX servers
-->

<html>
        <head>
                <title> Tracing Command Execution</title>

                        <script>
                                function leave() {
                                         opener.location.reload();
                                         window.close();
                                }
                        </script>

        </head>
                <body bgcolor=#A9E2F3>
                        <?php
                                session_start();
                                require('CheckSession.php');
                                $HostName=$_GET["hst"];
//                               $ClientName=$_GET["client"];
                                $ScriptName=$_GET["scriptname"];
                                $Action=$_GET["action"];
                                header('Content-Encoding: none;');
                                set_time_limit(0);
                                $username=$_SESSION['login_user'];
                                $output = shell_exec("../shell/AppendLog.sh $username handling a service on $HostName by executing following command - $ScriptName $Action");
//                                $handle = popen("ssh root@$HostName '/opt/scripts/LX_management_console/bin/CommandExecuter.sh $username $ScriptName $Action'", "r");
                                $handle = popen("/opt/scripts/eh_portal_scripts/bin/CommandExecuter.sh $HostName $username $ScriptName $Action", "r");

                                if (ob_get_level() == 0)
                                        ob_start();

                                        while(!feof($handle)) {
                                            $buffer = fgets($handle);
                                            $buffer = trim(htmlspecialchars($buffer));
                                            echo $buffer . "<br />";
                                            echo str_pad('', 512);
                                            ob_flush();
                                            flush();
 //                                           sleep(1);
                                        }

                                pclose($handle);
                                ob_end_flush();

 	                      ?>
		<p align=center> Script Execution completed</p>
                <p align=center><input type=button onclick=leave(); value=" close n refresh" /></p>
        </body>
</html>

