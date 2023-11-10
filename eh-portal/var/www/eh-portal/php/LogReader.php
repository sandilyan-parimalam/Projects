<!-- 
Developed By:Sandy
Desc:This script will invoke the target scripts which are located on LX servers
-->

<html>
        <head>
                <link rel="stylesheet" type="text/css" href="/eh-portal/css/LogViwer.css">

                <title> Log Viewer</title>

                        <script>
                                function leave() {
                                         window.close();
                                }
                        </script>

        </head>
                <body>

			<div class="logdiv">
                        <?php
                                session_start();
                                require('CheckSession.php');
                                header('Content-Encoding: none;');
                                set_time_limit(0);
                                $username=$_SESSION['login_user'];
                                $output = shell_exec("../shell/AppendLog.sh $username is reading logs");
                                $handle = popen("cat /var/www/eh-portal/logs/trace_action.log", "r");

                                if (ob_get_level() == 0)
                                        ob_start();

                                        while(!feof($handle)) {
                                            $buffer = fgets($handle);
                                            $buffer = trim(htmlspecialchars($buffer));
                                            echo $buffer . "<br />";
                                            echo str_pad('', 126);
                                            ob_flush();
                                            flush();
 //                                           sleep(1);
                                        }

                                pclose($handle);
                                ob_end_flush();

 	                      ?>
                <p align=center><input type=button onclick=leave(); value=" close" /></p>
		</div>
        </body>
</html>

