<html>
	<body>
	
		<head>
		<link rel="stylesheet" type="text/css" href="../css/tablestyle.css">
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
			<h2 align=center><?php echo strtoupper(gethostname());?> Management Portal </h2>
				<div class="CSSTableGenerator" >
				<?php
					$output = shell_exec('sudo /opt/scripts/lin_management_console/bin/GenerateLinInfo.sh');
					echo "$output";

				?>
			</div>

		</form>
	</body>
</html>
