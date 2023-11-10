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
		
				$client_name=$_GET["CNAME"];
				$cid=$_GET["CID"];
	                        $service=$_GET["SVC"];
        	                $action=$_GET["ACTION"];
				header('Content-Encoding: none;');
			        set_time_limit(0);
				$username=$_SESSION['login_user'];
	                        $output = shell_exec("../shell/AppendLog.sh $username handling a service by executing following command - $action $service");
			        $handle = popen("sudo vzctl exec $cid '/opt/scripts/maintenance_scripts/bin/menu.sh $action $service'", "r");

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
		<p align=center><input type=button onclick=leave(); value=" close n refresh" /></p>
	</body>
</html>
