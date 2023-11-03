<html>
<head>
<?php
session_start();
require('CheckSession.php');
?>
	<link rel="stylesheet" type="text/css" href="/eh-portal/css/LinDepForm.css">
    <title>LIN Management Portal</title>
    <script>
		var cid=""

		function hide_select() {
        document.getElementById("selecttomcat").style.display = "none";
        }
		
		function unhide_select() {
			var e = document.getElementById("getcid");
			var strUser = e.options[e.selectedIndex].value;
			var selected = e.options[e.selectedIndex].text;
			window.hostname = '<?=$_GET['hst']?>';
			var myWindow = window.open('LinDeployment.php?hst='+hostname+'&cid='+strUser+'&selected='+selected, '_self');
        }

	function go(){

                        var c = document.getElementById("selecttomcatnew");
                        var op = c.options[c.selectedIndex].value;
			unhide_select();
			alert(op);
			alert(cid);
  

	}

		
		window.onload = hide_select;
	</script>

</head>
<?php
$hst=$_GET['hst'];
$cid=$_GET['cid'];
?>
<body background="/eh-portal/images/LinDepFormImage.jpg">
	<form onsubmit="return confirm('Please Re-Check the given details \n Press OK if everthing is correct');" action=LinDeploymentTracer.php?hst='<?php echo $hst; ?>'&cid='<?php echo $cid; ?>' method="post">
        <div class="login">
			<p align=center><b><i><font color=white>  LIN Deployment Form</font></i></b></p><center>
				<table style="white-space:nowrap;">
					<?php
						$hst=$_GET['hst'];
						if (empty($_GET['cid'])) {
							
							echo '<tr><td> Select Client </td><td> <select id=getcid name=client_listing onChange="unhide_select(this);" style="text-indent: 1px; width: 100px; !important; min-width: 50px; max-width: 100px;">';
							
							$client_list = shell_exec("/opt/scripts/eh_portal_scripts/bin/GenerateLinDepForm.sh $hst listclient");
							
							echo "$client_list";
							
							echo "</select></td></tr>";
							
						
						}else {
							echo '<form action="LinDeploymentTracer.php" method=post>';
													
							echo '<tr><td>Selected Client</td><td><select id=getcid name=client_listing onChange="unhide_select(this);" style="text-indent: 1px; width: 100px; !important; min-width: 50px; max-width: 100px;">';
							echo "<option selected disabled >";
							echo  $_GET['selected'];
							echo "</option>";
									
 				                        echo "</select></td></tr>";
							
					                echo '<tr><td> Select Tomcat instance </td><td><select id="selecttomcatnew" name="SelectedTomcatInstance" style="text-indent: 1px; width: 150; !important; min-width: 50px; max-width: 100px;">';
							
				                        $contid=$_GET['cid'];
			                                 echo $contid;
							
							$tst = shell_exec("/opt/scripts/eh_portal_scripts/bin/GenerateLinDepForm.sh $hst listtomcatservices $contid");
							
							echo "$tst";
							echo '</select></td></tr>';
							echo '<tr><td> FTP Path </td><td><input type=text id=ftppath name=ftppath required /></td></tr>';
							
							echo '<tr><td> WAR file name </td><td><input name=warname type=text id=warname required /></td></td>';
							
							echo ' <tr> <td colspan=2 align=center><input type="submit" value="Deploy" ></td></tr>';
							echo '</form>';
                        }



                    ?>
		</table>
                </div>

                <div class="shadow">

                </div>

			</form>
</body>

</html>

