<html>
	<head>
	<title>Form</title>

	<?php

		$username=$_POST["username"];
		$password=$_POST["password"];
		$ResultString = system("sudo /opt/scripts/lin_management_console/bin/CheckLogin.sh $username $password");
                if( $ResultString == "success" ) {
                        session_start();
                        $_SESSION['login_user']= $username;
			$output = shell_exec("../shell/AppendLog.sh $username logging in");
			header("Location: /lin_administration/php/index.php");
			

                } else {
                        echo "<p align=center> <font color=red>";
                        echo "<script type='text/javascript'>alert('Login Failed');window.history.back();</script>";
			$output = shell_exec("../shell/AppendLog.sh login failed - username is $username and password is $password");


                }


	?>
	</head>


	<body>

	</body>
</html>
