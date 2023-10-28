<html>

		<head>
		<link rel="stylesheet" type="text/css" href="/eh-portal/css/LogViewer.css">
                <link rel="stylesheet" type="text/css" href="/eh-portal/css/menu.css">

<?php
session_start();
require('CheckSession.php');
$username=$_SESSION['login_user'];
?>

<style>


.loader {position: absolute;top: 40%;left: 45%;z-index: 100}

select{
	width:150px;

}

</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js" > </script>
<script>



   $(window).load(function() {
        // will only fire AFTER all pages assets have loaded
 $("#maindiv").load('LogReader.php');
    })





</script>

</head>
<body background="/eh-portal/images/background.jpg">

		<form>

			<title> Log Viewer </title>
        <p align=right><font color=green><b><strong>Welcome <?php echo $_SESSION['login_user']; ?> <font color=red>| </font><a href="LogOut.php?username=<?php echo $_SESSION['login_user']; ?>" style="text-decoration:none;color:green;"> Logout  </a></strong></b></font> </p>

                        <p align=right><font color=green><i><a href=home.php>Home</a></i></font> </p>

			<h2 align=center> <font color=green></i>Log Viwer</i></font></h2>
<ul>
  <li><a class="active" href="LogViwer.php">Latest Log</a></li>
  <li><a href="ArchiveLogReader.php" target="_blank">Log Archives</a></li>
  </ul>
</ul>

                                <div class="datagrid" id="maindiv">
						<p align=center class="loader" style="color:green;font-size:20px;"></b><i>
						Please wait while fetching the data</br></i></b>
						<img src=/eh-portal/images/page-loader.gif />
						</p>

                        </div>

		</form>
	</body>
</html>
