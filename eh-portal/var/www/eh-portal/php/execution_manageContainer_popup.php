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
                                $hst=$_GET["hst"];
                                header('Content-Encoding: none;');
                                set_time_limit(0);
                                $username=$_SESSION['login_user'];
                                $output = shell_exec("../shell/AppendLog.sh $username is starting a container - container ID is $cid");
	
                                $handle = popen("/opt/scripts/eh_portal_scripts/bin/StartContainer.sh $hst $cid", "r");

                                if (ob_get_level() == 0)
                                        ob_start();

                                        while(!feof($handle)) {
                                            $buffer = fgets($handle);
                                            $buffer = trim(htmlspecialchars($buffer));
                                            echo $buffer . "<br />";
                                            echo str_pad('', 512);
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

