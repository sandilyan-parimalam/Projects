<html>
	<body background="/lin_administration/images/bgimage.jpg">
	
		<head>
		<link rel="stylesheet" type="text/css" href="/lin_administration/css/tablestyle.css">
                <link rel="stylesheet" type="text/css" href="/lin_administration/css/menu.css">


<?php
session_start();
require('CheckSession.php');
$username=$_SESSION['login_user'];
?>

<script>

var myWindow;
function PopUp(cname, cid, svc, action) {
	var option = window.prompt("You are going to " + action +" "+ svc + "\n         Are you sure???", "give yes or no");

	if ( option == "yes" && cname && cid && svc && action) {
		myWindow = window.open('execution_manageSVC_popup.php?CNAME='+ cname +'&&CID='+ cid +'&&SVC='+ svc +'&&ACTION='+ action+' ', "myWindow", "dialog=yes,toolbar=no,menubar=no,width=500, top=100, left=500, height=500");
	}
}	

function ManageContainer(contid, clientname,state) {

if ( state != "running" ) {
                var opt = window.prompt("You are going to start the container \n	Container ID         :  " + contid + "\n	Container Name :  " + clientname + "\n\n              Are you sure???", "give yes or no");
                if ( opt == "yes" && contid && clientname && state) {
                        myWindow = window.open('execution_manageContainer_popup.php?CID='+ contid +'', "myWindow", "dialog=yes,toolbar=no,menubar=no,width=500, top=100, left=500, height=500");
                }
}

}


</script>
		</head>


		<form>

			<title> LIN Management Console </title>
                        <p align=right><font color=green><i>Welcome <?php echo $_SESSION['login_user']; ?></i></font> </p>
			<h2 align=center> <font color=green></i><?php echo strtoupper(gethostname());?> Management Portal</i></font></h2>

<ul>
  <li><a href="#" onclick='alert("this page is under construction");'>Dashboard</a></li>
  <li><a class="active" href="index.php">Controll Panel</a></li>
  <li><a href="LinDeployment.php" target="_blank">Lin Deployment</a></li>
  <li><a href="index.php">Reload Data</a></li>
    <li><a href="About.php">About</a></li>
    <li><a href="LogOut.php?username=<?php echo $_SESSION['login_user']; ?>"> Logout  </a></li>
  </ul>
</ul>
				<div class="CSSTableGenerator" >
				<?php
					$output = shell_exec('sudo /opt/scripts/lin_management_console/bin/GenerateLinInfo.sh');
					echo "$output";

				?>
			</div>

		</form>
	</body>
</html>
