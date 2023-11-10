<html>
<head>
	<title> EH Portal Home </title>
                <link rel="stylesheet" type="text/css" href="/eh-portal/css/home.css">
		<link href='http://fonts.googleapis.com/css?family=Aldrich' rel='stylesheet' type='text/css'>

                <?php
                        session_start();
                        require('CheckSession.php');
                        $username=$_SESSION['login_user'];
                ?>



</head>	

<body  background="/eh-portal/images/homebgimage.jpg"> 
	<p align=right><font color=white><b><strong>Welcome <?php $usr= $_SESSION['login_user']; echo $usr; ?> <font color=red>| </font><a href="LogOut.php?username=<?php echo $_SESSION['login_user']; ?>" style="text-decoration:none;color:white;"> Logout  </a></strong></b></font> </p>
        <h2> Welcome to  mytestorg Health Management Portal </h2>



		<div class="div_items">
			
			<p class="div_title">LIN Portals</p>

			<ul style="border-top: 1px solid black;">
                          <li><a  href="/eh-portal/php/linvz_portal.php" target="_blank"><font color=green>ASPLINVZ</font></a></li>
			  <li><a  href="/eh-portal/php/lin3vz_portal.php" target="_blank"><font color=green>ASPLIN3VZ</font></a></li>





			</ul>

		</div>

                <div class="div_items">

                        <p class="div_title">LX Portals</p>


                        <ul style="border-top: 1px solid black;">
                          <li><a  href="/eh-portal/php/asp1m_portal.php" target="_blank"><font color=green>ASP1M</font></a></li>
                          <li><a  href="/eh-portal/php/asp2m_portal.php" target="_blank"><font color=green>ASP2M</font></a></li>
                          <li><a  href="/eh-portal/php/ncalive_portal.php" target="_blank"><font color=green>NCALIVE</font></a></li>
                          <li><a  href="/eh-portal/php/alicolive_portal.php" target="_blank"><font color=green>ALICOLIVE</font></a></li>
                          <li><a  href="/eh-portal/php/aiglive_portal.php" target="_blank"><font color=green>AIGLIVE</font></a></li>
                          <li><a  href="/eh-portal/php/ihcuat_portal.php" target="_blank"><font color=green>IHCUAT</font></a></li>

			</ul>

                        <ul style="border-top: 1px solid black;">
                          <li><a  href="/eh-portal/php/asptest1n_portal.php" target="_blank"><font color=green>ASPTEST1N</font></a></li>
                          <li><a  href="/eh-portal/php/asptest2n_portal.php" target="_blank"><font color=green>ASPTEST2N</font></a></li>
                          <li><a  href="/eh-portal/php/ncatestn_portal.php" target="_blank"><font color=green>NCATESTN</font></a></li>
                          <li><a  href="/eh-portal/php/alicotest_portal.php" target="_blank"><font color=green>ALICOTEST</font></a></li>
                          <li><a  href="/eh-portal/php/aigtest_portal.php" target="_blank"><font color=green>AIGTEST</font></a></li>

			</ul>

	                <p class="div_title">Tools</p>
                        <ul style="border-top: 1px solid black;">
                          <li><a  href="http://192.168.250.215:3000" target="_blank"><font color=green>OpenVZ Web Panel 2.4</font></a></li>
                          <li><a  href="http://192.168.250.215/syspass/" target="_blank"><font color=green>SYSPASS</font></a></li>

                        </ul>


                </div>



</body>
</html>
