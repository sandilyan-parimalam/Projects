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
                                $cid=$_GET["CID"];
                                header('Content-Encoding: none;');
                                set_time_limit(0);
                                $username=$_SESSION['login_user'];
                                $output = shell_exec("../shell/AppendLog.sh $username is starting a container - container ID is $cid");
	
                                $handle = popen("sudo vzctl start $cid", "r");

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
                <p align=center><input type=button onclick=leave(); value=" close n refresh " /></p>
        </body>
</html>

