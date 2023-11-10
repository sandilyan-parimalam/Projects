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
				$hst=$_GET["hst"];
				$client_name=$_GET["CNAME"];
				$cid=$_GET["CID"];
	                        $service=$_GET["SVC"];
        	                $action=$_GET["ACTION"];
				header('Content-Encoding: none;');
			        set_time_limit(0);
				$username=$_SESSION['login_user'];
	                        $output = shell_exec("../shell/AppendLog.sh $username handling a service by executing following command - $action $service");
			        $handle = popen("/opt/scripts/eh_portal_scripts/bin/HandleService.sh $hst $cid $action $service", "r");

			        if (ob_get_level() == 0) 
					ob_start();

				        while(!feof($handle)) {
				            $buffer = fgets($handle);
				            $buffer = trim(htmlspecialchars($buffer));
				            echo $buffer . "<br />";
				            echo str_pad('', 512);    
				            ob_flush();
        				    flush();
				        }

			        pclose($handle);
			        ob_end_flush();

			?>
		<p align=center><input type=button onclick=leave(); value=" close n refresh" /></p>
	</body>
</html>
