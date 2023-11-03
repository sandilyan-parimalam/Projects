<html>
	<head>

	<?php

		$username=$_POST["username"];
		$password=$_POST["password"];

                if( $username == "root" ) {

                        echo "<p align=center> <font color=red>";
                        echo "<script type='text/javascript'>alert('SECURITY VIOLATION  \\nget/use  LDAP  account ');window.history.back();</script>";

                }else {

			$ResultString = system("/opt/scripts/tpp_portal_scripts/bin/CheckLogin.sh $username '$password'");

		}

                if( $ResultString == "success" ) {
                        session_start();
                        $_SESSION['login_user']= $username;
			$output = shell_exec("../shell/AppendLog.sh $username logging in");
			header("Location: /tpp-portal/php/home.php");
			

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
