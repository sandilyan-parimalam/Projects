

<html>

		<head>
		<link rel="stylesheet" type="text/css" href="/eh-portal/css/tablestyle.css">
                <link rel="stylesheet" type="text/css" href="/eh-portal/css/menu.css">

<?php
session_start();
require('CheckSession.php');
$username=$_SESSION['login_user'];
?>

<style>


.loader {position: absolute;top: 40%;left: 45%;z-index: 100}


</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js" > </script>
<script>
   $(window).load(function() {
        // will only fire AFTER all pages assets have loaded
 $("#maindiv").load('GenerateTable.php?srv=linvz');
    })
</script>
<script>

var myWindow;
function PopUp(cname, cid, svc, action) {
	var option = window.prompt("You are going to " + action +" "+ svc + "\n         Are you sure???", "give yes or no");

	if ( option == "yes" && cname && cid && svc && action) {
		var myWindow = window.open('execution_manageSVC_popup.php?hst=linvz&&CNAME='+ cname +'&&CID='+ cid +'&&SVC='+ svc +'&&ACTION='+ action+' ', "", "dialog=yes,toolbar=no,menubar=no,width=500, top=100, left=500, height=500");
	}
}	

function ManageContainer(contid, clientname,state) {

if ( state != "running" ) {
                var opt = window.prompt("You are going to start the container \n	Container ID         :  " + contid + "\n	Container Name :  " + clientname + "\n\n              Are you sure???", "give yes or no");
                if ( opt == "yes" && contid && clientname && state) {
                        myWindow = window.open('execution_manageContainer_popup.php?hst=linvz&CID='+ contid +'', "", "dialog=yes,toolbar=no,menubar=no,width=500, top=100, left=500, height=500");
                }
}

}


</script>

</head>
<body background="/eh-portal/images/background.jpg">

		<form>

			<title> LIN Management Console </title>
        <p align=right><font color=green><b><strong>Welcome <?php echo $_SESSION['login_user']; ?> <font color=red>| </font><a href="LogOut.php?username=<?php echo $_SESSION['login_user']; ?>" style="text-decoration:none;color:green;"> Logout  </a></strong></b></font> </p>

                        <p align=right><font color=green><i><a href=home.php>Home</a></i></font> </p>

			<h2 align=center> <font color=green></i>ASPLINVZ Management Portal</i></font></h2>

<ul>
  <li><a class="active" href="linvz_portal.php">Controll Panel</a></li>
  <li><a href="LinDeployment.php?hst=linvz" target="_blank">Lin Deployment</a></li>
  <li><a href="linvz_portal.php">Reload Data</a></li>
    <li><a href="About.php">About</a></li>
    <li><a href="LogOut.php?username=<?php echo $_SESSION['login_user']; ?>"> Logout  </a></li>
  </ul>
</ul>
                                <div class="CSSTableGenerator" id="maindiv">
						<p align=center class="loader" style="color:green;font-size:20px;"></b><i>
						Please wait while fetching the data</br></i></b>
						<img src=/eh-portal/images/page-loader.gif />
						</p>

                        </div>

		</form>
	</body>
</html>
