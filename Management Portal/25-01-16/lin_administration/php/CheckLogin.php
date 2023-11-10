<html>
	<head>
	<title>Form</title>

	<?php

		$username=$_POST["username"];
		$password=$_POST["password"];
		$ResultString = system("sudo /opt/scripts/lin_management_console/bin/CheckLogin.sh $username $password");
                if( $ResultString == success ) {
                        session_start();
                        $_SESSION['login_user']= $username;
                        header("Location: /lin_administration/php/index.php");
                        //echo "<script type='text/javascript'>window.location.href = '/lin_administration/php/index.php'</script>";

                } else {
                        echo "<p align=center> <font color=red>";
                        echo "<script type='text/javascript'>alert('Login Failed');window.history.back();</script>";


                }


	?>
	</head>


	<body>

	</body>
</html>
