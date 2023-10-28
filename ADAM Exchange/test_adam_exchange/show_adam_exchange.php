<?php
$URL=$_SERVER['PHP_SELF'] ;
header("Expires: Sat, 01 Jan 2000 00:00:00 GMT");
header("Last-Modified: ".gmdate("D, d M Y H:i:s")." GMT");
header("Cache-Control: post-check=0, pre-check=0",false);
session_cache_limiter("must-revalidate");
session_start();
session_register("login");
$location="";
$function="";
$status="";
$login="";


$username="root";$password="root";
$database="ocsweb";mysql_connect(localhost,$username);
@mysql_select_db($database) or die( "Unable to select database");
$query="SELECT * FROM adamexchange";$result=mysql_query($query);
$num=mysql_numrows($result);mysql_close();

echo "<h1 align=center>  ADAM EXCHANGE </h1><br>";
echo "<table border=1 align=center>";
echo '<tr align=left bgcolor=#01DFD7>
<th>NO</th>
<th>Display Name</th>
<th>Total Item Size</th>
<th>Item Count</th>
<th>Database Name</th>
</tr>';

for ($i=1; $i < $num; $i++) { 
echo "<tr align=left bgcolor=#dcd9c9>";
$output=mysql_result($result,$i,"DisplayName");
$output1=mysql_result($result,$i,"TotalItemSize");
$output2=mysql_result($result,$i,"ItemCount");
$output3=mysql_result($result,$i,"DatabaseName");
echo "<th>".$i."</th>";
echo "<th>".$output."</th>";
echo "<th>".$output1."</th>";
echo "<th>".$output2."</th>";
echo "<th>".$output3."</th>";
echo "</tr>";
echo '</font>';
}
echo "</table>";
?>

