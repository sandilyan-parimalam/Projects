<html>

		<head>
		<link rel="stylesheet" type="text/css" href="/eh-portal/css/LX_tablestyle.css">
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


function LoadActions(ClientName) {

        var SelectBoaxName="ServiceName_"+ClientName+"";
        var ServiceStatus=document.getElementById(SelectBoaxName).value;
	var ActionListBoxName="ActionsList_"+ClientName+"";

	if(ServiceStatus.indexOf("up:")>=0){
		document.getElementById(ActionListBoxName).innerHTML = "<option selected disabled>Select Action </option><option value=stop> Stop </option><option value=restart> Restart </option>";
	        document.getElementById(ActionListBoxName).style.display = "block";


	}else if(ServiceStatus.indexOf("partiallydown:")>=0) {

                document.getElementById(ActionListBoxName).innerHTML = "<option selected disabled>Select Action </option><option value=stop> Stop </option><option value=start> Start </option><option value=restart> Restart </option>";
                document.getElementById(ActionListBoxName).style.display = "block";


	 
	} else {

                document.getElementById(ActionListBoxName).innerHTML = "<option selected disabled>Select Action </option><option value=start> Start </option>";
                document.getElementById(ActionListBoxName).style.display = "block";
	
	}


}



function UnHideButton(button_client) {
        document.getElementById(button_client).style.display = "inline";



}


function Go(Client){
	

        var SelectBoaxName="ServiceName_"+Client+"";
        var ServiceStatus=document.getElementById(SelectBoaxName).value;

	if(ServiceStatus.indexOf("lxcomsvr")>=0){

	//var SelectedService = ServiceStatus.split("_", 2);
	//var ScriptName = "lxcomsvr_"+SelectedService+"";
	var ScriptName = ServiceStatus.replace(/_down:|/gm,'');
        var ScriptName = ScriptName.replace(/_up:|/gm,'');
        var ScriptName = ScriptName.replace(/_partiallydown:|/gm,'');


	
	} else if(ServiceStatus.indexOf("hipaa")>=0){

        var ScriptName = ServiceStatus.replace(/_down:|/gm,'');
        var ScriptName = ScriptName.replace(/_up:|/gm,'');

        }else {

        var ScriptName = ServiceStatus.replace(/_down:|/gm,'');
        var ScriptName = ScriptName.replace(/_up:|/gm,'');

	}

        var SelectedActionBox="ActionsList_"+Client+"";
        var SelectedAction=document.getElementById(SelectedActionBox).value;
	var option = prompt("You are going to "+SelectedAction+" a service of " +Client+ " on aiglive \ncommand : /etc/init.d/"+ScriptName+" "+SelectedAction+"\nAre you sure???", "give yes or no" );

	if ( option == "yes" ) {

	var myWindow = window.open('LXCommandTracer.php?hst=aiglive&scriptname='+ScriptName+'&action='+SelectedAction+' ', "", "dialog=yes,location=no,scrollbars=yes,toolbar=no,menubar=no,width=600, top=100, left=500, height=500");
	}

}

   $(window).load(function() {
        // will only fire AFTER all pages assets have loaded
 $("#maindiv").load('GenerateTable.php?srv=aiglive');
    })





</script>

</head>
<body background="/eh-portal/images/bgimage.jpg">

		<form>

			<title> LX Management Console </title>
        <p align=right><font color=green><b><strong>Welcome <?php echo $_SESSION['login_user']; ?> <font color=red>| </font><a href="LogOut.php?username=<?php echo $_SESSION['login_user']; ?>" style="text-decoration:none;color:green;"> Logout  </a></strong></b></font> </p>

                        <p align=right><font color=green><i><a href=home.php>Home</a></i></font> </p>

			<h2 align=center> <font color=green></i>AIGLIVE Management Portal</i></font></h2>
                                <div class="datagrid" id="maindiv">
						<p align=center class="loader" style="color:green;font-size:20px;"></b><i>
						Please wait while fetching the data</br></i></b>
						<img src=/eh-portal/images/page-loader.gif />
						</p>

                        </div>

		</form>
	</body>
</html>
