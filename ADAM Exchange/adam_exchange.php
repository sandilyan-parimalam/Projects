<?php 
header("Expires: Sat, 01 Jan 2000 00:00:00 GMT");
header("Last-Modified: ".gmdate("D, d M Y H:i:s")." GMT");
header("Cache-Control: post-check=0, pre-check=0",false);
session_cache_limiter("must-revalidate");
session_start();
if (!session_is_registered("SESSION")) {
        header("Location: login.php");
        exit();
}

$username="root";
$password="root";
$database="ocsweb";
?>
<html>
<body>
<script src='utility.js'></script> 
 <H3> Employees with both Exchange & RS --by Office </H3>
<?php include 'link.php'; ?>

<table border="1" cellspacing="2" cellpadding="2" id=Savvis.tbl width=1000> 
<?php
mysql_connect('ocsofficedb',$username,$password);
@mysql_select_db($database) or die( "Unable to select database");
$query1="select exchange.name from exchange  join rackspace_email on exchange.email = rackspace_email.email group by exchange.name ;";
$result1=mysql_query($query1);
$totexchange=mysql_numrows($result1);

?>
<tr  bgcolor= bbeeee >
<th><a onclick=ts_resortTable(this);return false; class=sortheader  href= #> No<span class=sortarrow></span></a></th>
<th><a onclick=ts_resortTable(this);return false; class=sortheader  href= #> Office<span class=sortarrow></span></a></th>
<th><a onclick=ts_resortTable(this);return false; class=sortheader  href= #> Current<span class=sortarrow></span></a></th>
<th><a onclick=ts_resortTable(this);return false; class=sortheader  href= #> Ex-Employee<span class=sortarrow></span></a></th>
<th><a onclick=ts_resortTable(this);return false; class=sortheader  href= #> Total<span class=sortarrow></span></a></th>
</tr>
<?php
 
mysql_connect('ocsofficedb',$username,$password);
@mysql_select_db($database) or die( "Unable to select database");
$query2="SELECT DISTINCT division FROM iemployees  WHERE division REGEXP '^[a-zA-z]' order by division asc;";
$result2=mysql_query($query2);
$totoffice=mysql_numrows($result2);
mysql_close();
$n=0;
while ( $n <$totoffice)
{
$office=mysql_result($result2,$n,"division");
$f1=$office;
mysql_connect('ocsofficedb',$username,$password);
@mysql_select_db($database) or die( "Unable to select database");
$query1="select iemployees.email from exchange join rackspace_email on rackspace_email.email=exchange.email join iemployees on exchange.email=iemployees.email where iemployees.division='$f1'  group by exchange.name ;";
$result1=mysql_query($query1);
$exchange=mysql_numrows($result1);
$query1="select iemployees.email from exchange join rackspace_email on rackspace_email.email=exchange.email join iemployees on exchange.email=iemployees.email where iemployees.division='$f1' and iemployees.status='Current' group by exchange.name ;";
$result1=mysql_query($query1);
$exchangecur=mysql_numrows($result1);
$query1="select iemployees.email from  exchange join rackspace_email on rackspace_email.email=exchange.email join iemployees on exchange.email=iemployees.email  where iemployees.division='$f1' and iemployees.status='ex-employee' group by exchange.name ;";
$result1=mysql_query($query1);
$exchangeex=mysql_numrows($result1);
mysql_close();
$totalexchangeex=$totalexchangeex+$exchangeex;
$totalexchangecur=$totalexchangecur+$exchangecur;
$totalexchange=$totalexchange+$exchange;
$m=$n+1;
if ($n % 2)
$bg="bgcolor = #ccc9c8" ;
else
$bg="bgcolor = #dcd9c9" ;
$ff1=str_replace(" ","%20",$office);
echo "<tr ".$bg."> <td align=right>".$m."</td>";
?>
<td alight=right><?echo $office?></td>
<td align=right><?php echo "<a href=exgrs.php?location=".$ff1."&function=exchange&status=current>".$exchangecur."</a>" ; ?></td>
<td align=right><?php echo "<a href=exgrs.php?location=".$ff1."&function=exchange&status=Ex-employee>".$exchangeex."</a>" ; ?></td>
<td align=right><?php echo "<a href=exgrs.php?location=".$ff1."&function=exchange>".$exchange."</a>" ; ?></td>
<?php
$n++;
$oexchange=$totexchange-$totalexchange;
}
?>
</tr>
<tr class=sortbottom bgcolor = #dcd9c9>
<td align=right><?php echo $n+1; ?></td>
<td align=left><?php echo "EE Total"; ?></td>
<td align=right><?php echo "<a href=exgrs.php?location=all&function=exchange&status=current>".number_format($totalexchangecur,0)."</a>" ; ?></td>
<td align=right><?php echo "<a href=exgrs.php?location=all&function=exchange&status=ex-employee>".number_format($totalexchangeex,0)."</a>" ; ?></td>
<td align=right><?php echo "<a href=exgrs.php?location=all&function=exchange>".number_format($totalexchange,0)."</a>" ; ?></td>
</tr>
<tr class=sortbottom bgcolor = #dcd9c9>
<td align=right><?php echo $n+2; ?></td>
<td align=left><?php echo "Orphan"; ?></td>
<td></td><td></td>
<td align=right><?php echo "<a href=exgrs.php?function=exchangeall&orphan=".$oexchange.">".number_format($oexchange,0)."</a>" ; ?></td>
</tr>
<tr class=sortbottom bgcolor = #dcd9c9>
<td align=right><?php echo $n+2; ?></td>
<td align=left><?php echo "Total"; ?></td>
<td></td><td></td>
<td align=right><?php echo "<a href=exgrs.php?location=everything&function=exchangeall>".number_format($totexchange,0)."</a>" ; ?></td>
</tr>

</table>
</body>
</html>

