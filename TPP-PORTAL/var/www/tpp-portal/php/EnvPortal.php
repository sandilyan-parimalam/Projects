<html>
<head>

                <?php
                        session_start();
                        require('CheckSession.php');
                        $username=$_SESSION['login_user'];
			$ENVName=$_GET['env'];
                ?>

       <title> <?php echo $ENVName; ?> Portal Home </title>
                <link rel="stylesheet" type="text/css" href="/tpp-portal/css/EnvPortal.css">


<script>

function LoadInstanceTypeList(SelectBoxDetails) {
	var TypeListBox=""+SelectBoxDetails+"_InstanceTypeList";
	var OPT=""+SelectBoxDetails+"_ActionList";
        var OPT=document.getElementById(OPT).value;
        var GoName=""+SelectBoxDetails+"_submit";
        var Hidejbossopt=""+SelectBoxDetails+"_jboss";
        var HidejbossBox=""+SelectBoxDetails+"_jboss_InstanceList";
        var HideihubBox=""+SelectBoxDetails+"_ihub_InstanceList";
        var FTPBoxName=""+SelectBoxDetails+"_FTP_Path";
        var FileNameBox=""+SelectBoxDetails+"_FileName";
	document.getElementById(FTPBoxName).setAttribute("disabled", true);
        document.getElementById(FileNameBox).setAttribute("disabled", true);
        document.getElementById(TypeListBox).style.display = "block";




if(OPT.indexOf("Check Bundle Status")>=0){
	document.getElementById(TypeListBox).style.display = "block";
        document.getElementById(HideihubBox).style.display = "block";
        document.getElementById(HidejbossBox).style.display = "none";
        document.getElementById(FTPBoxName).style.display = "none";
        document.getElementById(FileNameBox).style.display = "none";
        document.getElementById(FTPBoxName).setAttribute("disabled", true);
        document.getElementById(FileNameBox).setAttribute("disabled", true);
        document.getElementById(Hidejbossopt).style.display = "none";
        document.getElementById(TypeListBox).selectedIndex = 0;
        var HideBox=""+SelectBoxDetails+"_ihub_InstanceList";
        document.getElementById(HideBox).style.display = "none";
        document.getElementById(GoName).style.display = "none";









}else {
        document.getElementById(GoName).style.display = "none";
	document.getElementById(TypeListBox).selectedIndex = 0;
        document.getElementById(HidejbossBox).selectedIndex = 0;
        document.getElementById(HideihubBox).selectedIndex = 0;
        document.getElementById(HidejbossBox).style.display = "none";
        document.getElementById(HideihubBox).style.display = "none";
	document.getElementById(TypeListBox).style.display = "block";
        document.getElementById(TypeListBox).disabled = false;
        document.getElementById(FTPBoxName).style.display = "none";
       document.getElementById(FileNameBox).style.display = "none";
        document.getElementById(FTPBoxName).setAttribute("disabled", true);
        document.getElementById(FileNameBox).setAttribute("disabled", true);
        document.getElementById(Hidejbossopt).style.display = "block";




}



}

function LoadInstanceList(SelectBoxDetails) {
	var InstanceListBox=""
	var SelectedType=""
	var LodableBox=""


        var InstanceListBox=""+SelectBoxDetails+"_InstanceTypeList";
        var SelectedType=document.getElementById(InstanceListBox).value;
        var LodableBox=""+SelectBoxDetails+"_"+SelectedType+"_InstanceList";
        var GoName=""+SelectBoxDetails+"_submit";
        var FTPBoxName=""+SelectBoxDetails+"_FTP_Path";
        var FileNameBox=""+SelectBoxDetails+"_FileName";


	if(SelectedType.indexOf("jboss")>=0){
	        var HideBox=""+SelectBoxDetails+"_ihub_InstanceList";
		document.getElementById(HideBox).selectedIndex = 0;
	        document.getElementById(HideBox).style.display = "none";
                document.getElementById(GoName).style.display = "none";
	        document.getElementById(FTPBoxName).style.display = "none";
               document.getElementById(FileNameBox).style.display = "none";
        document.getElementById(FTPBoxName).setAttribute("disabled", true);
        document.getElementById(FileNameBox).setAttribute("disabled", true);


		


	}else {
                var HideBox=""+SelectBoxDetails+"_jboss_InstanceList";
                document.getElementById(HideBox).selectedIndex = 0;
	        document.getElementById(HideBox).style.display = "none";
                document.getElementById(GoName).style.display = "none";
	        document.getElementById(FTPBoxName).style.display = "none";
               document.getElementById(FileNameBox).style.display = "none";
        document.getElementById(FTPBoxName).setAttribute("disabled", true);
        document.getElementById(FileNameBox).setAttribute("disabled", true);


	}

	document.getElementById(LodableBox).style.display = "block";



}

function ShowGo(GoNameDetails) {

	var GoName="";
	var GoName=""+GoNameDetails+"_submit";
        var OPT=""+GoNameDetails+"_ActionList";
        var FTPBoxName=""+GoNameDetails+"_FTP_Path";
        var FileNameBox=""+GoNameDetails+"_FileName";
        var OPT=document.getElementById(OPT).value;

	if(OPT.indexOf("Deploy Build")>=0 || OPT.indexOf("Apply Patch")>=0){

        document.getElementById(FTPBoxName).value = "";
        document.getElementById(FileNameBox).value = "";

	document.getElementById(FTPBoxName).style.display = "block";
        document.getElementById(FileNameBox).style.display = "block";
        document.getElementById(GoName).style.display = "block";
        document.getElementById(FTPBoxName).removeAttribute("disabled");
        document.getElementById(FileNameBox).removeAttribute("disabled");


		
	}else if(OPT.indexOf("Revert")>=0 ) {

        document.getElementById(FileNameBox).value = "";

        document.getElementById(FileNameBox).style.display = "block";
        document.getElementById(GoName).style.display = "block";
        document.getElementById(FileNameBox).removeAttribute("disabled");



}

	else{
        document.getElementById(GoName).style.display = "block";
	}


}


function Go(ENV) {

        var SelectedActionBoxName=""+ENV+"_ActionList";
        var SelectedAction=document.getElementById(SelectedActionBoxName).value;

        var SelectedTypeBoxName=""+ENV+"_InstanceTypeList";
        var SelectedType=document.getElementById(SelectedTypeBoxName).value;

        var SelectedInstanceBoxName=""+ENV+"_"+SelectedType+"_InstanceList";
        var SelectedInstance=document.getElementById(SelectedInstanceBoxName).value;

	var args=ENV+"_"+SelectedType+"_"+SelectedInstance+"_"+SelectedAction;
	
        var OPT=""+ENV+"_ActionList";
        var OPT=document.getElementById(OPT).value;

        var FTPBoxName=""+ENV+"_FTP_Path";
        var FileNameBox=""+ENV+"_FileName";
        var FTPPath=document.getElementById(FTPBoxName).value;
        var FileName=document.getElementById(FileNameBox).value;

	        if(OPT.indexOf("Deploy Build")>=0 || OPT.indexOf("Apply Patch")>=0){

                        var opt = window.prompt("\t\tYou have Selected below\n\n\tAction\t\t:\t"+SelectedAction+"\n\tInstance Type\t:\t"+SelectedType+"\n\tInstance\t\t:\t"+SelectedInstance+"\n\twhere\t\t:\t"+ENV+"\n\tFTP Path\t\t:\t"+FTPPath+"\n\tFile Name\t\t:\t"+FileName+"\n\n\t\t\tAre you sure???", "give yes or no");

				if ( opt == "yes") {
						var args=args+" "+FTPPath+" "+FileName;
			        	        myWindow = window.open('CommandExecuter.php?args='+ args, "", "location=no,status=yes,scrollbars=yes,width=800,height=800");
				        }


		}else if( OPT.indexOf("Revert")>=0 ){
                        var opt = window.prompt("\t\tYou have Selected below\n\n\tAction\t\t:\t"+SelectedAction+"\n\tInstance Type\t:\t"+SelectedType+"\n\tInstance\t\t:\t"+SelectedInstance+"\n\twhere\t\t:\t"+ENV+"\n\tFile Name\t\t:\t"+FileName+"\n\n\t\t\tAre you sure???", "give yes or no");

                                if ( opt == "yes") {
                                                var args=args+" "+FTPPath+" "+FileName;
                                                myWindow = window.open('CommandExecuter.php?args='+ args, "", "location=no,status=yes,scrollbars=yes,width=800,height=800");
                                        }
		}


		else{
			var opt = window.prompt("	You have Selected below\n\nAction		:	"+SelectedAction+"\nInstance Type	:       "+SelectedType+"\nInstance		:	"+SelectedInstance+"\nwhere		:	"+ENV+"\n\n	Are you sure???", "give yes or no");

				 if ( opt == "yes") {
				                myWindow = window.open('CommandExecuter.php?args='+ args, "", "location=no,status=yes,scrollbars=yes,width=800,height=800");
				       }

		}





}

</script>
</head>	

<body  background="/tpp-portal/images/env_background.jpg">
	<p align=right><font color=white><b><strong>Welcome <?php $usr= $_SESSION['login_user']; echo $usr; ?> <font color=red>| </font><a href="LogOut.php?username=<?php echo $_SESSION['login_user']; ?>" style="text-decoration:none;color:white;"> Logout  </a></strong></b></font> </p>
        <h2>  <?php echo $ENVName; ?> Management Portal </h2>
<?php
$GenInfo = system("/opt/scripts/tpp_portal_scripts/bin/GenerateInfo.sh $ENVName");
?>

                </div>
                                        <div class="copy-right">
                                        <p class="footer"><hr>Copyright - 2016 mytestorg Inc. </p>
                                        </div>



</body>
</html>
