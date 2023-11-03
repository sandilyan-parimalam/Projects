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
                                $arguments=$_GET["args"];
                                header('Content-Encoding: none;');
                                set_time_limit(0);
                                $username=$_SESSION['login_user'];
                                $output = shell_exec("../shell/AppendLog.sh $username executing following command - $arguments");
                                $handle = popen("/opt/scripts/tpp_portal_scripts/bin/CommandExecuter.sh $arguments $username", "r");

                                if (ob_get_level() == 0)
                                        ob_start();

                                        while(!feof($handle)) {
                                            $buffer = fgets($handle);
                                            $buffer = trim(htmlspecialchars($buffer));
                                            echo "<pre>".$buffer."</pre>" ;
                                            echo str_pad('','50' );
                                            ob_flush();
                                            flush();
                                        }

                                pclose($handle);
                                ob_end_flush();

 	                      ?>
		
		<p align=center> Script Execution completed</p>
                <p align=center><input type=button onclick=leave(); value=" close n refresh" /></p>
        </body>
</html>

