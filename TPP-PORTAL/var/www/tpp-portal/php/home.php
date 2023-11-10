<html>
<head>
	<title> TPP Portal Home </title>
                <link rel="stylesheet" type="text/css" href="/tpp-portal/css/home.css">
		<link href='http://fonts.googleapis.com/css?family=Aldrich' rel='stylesheet' type='text/css'>

                <?php
                        session_start();
                        require('CheckSession.php');
                        $username=$_SESSION['login_user'];
                ?>



</head>	

<body  background="/tpp-portal/images/home_background.jpg"> 
	<p align=right><font color=white><b><strong>Welcome <?php $usr= $_SESSION['login_user']; echo $usr; ?> <font color=red>| </font><a href="LogOut.php?username=<?php echo $_SESSION['login_user']; ?>" style="text-decoration:none;color:white;"> Logout  </a></strong></b></font> </p>
        <h2> Welcome to TPP Management Portal </h2>

		<div class="div_items">
			
			<p class="div_title">Projects</p>

			<ul style="border-top: 1px solid black;">
			<?php
				$GenInfo = system("/opt/scripts/tpp_portal_scripts/bin/GenerateEnvList.sh");
			?>
			</ul>

		</div>
                                        <div class="copy-right">
					<p class="footer"><hr>Copyright - 2016 mytestorg Inc. </p>
                                        </div>


</body>
</html>
