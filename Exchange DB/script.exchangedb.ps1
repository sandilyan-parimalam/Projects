clear
echo "******************************************************************************************************************************************************************************************"
$fname = Read-Host "Enter folder name"
if (Test-Path "c:\SCRIPT\$fname")
{
echo ""
echo ""
echo "DIRECTORY ALREADY EXISTS"
echo ""
echo ""
echo "DELETING EXISTING DIRECTORY"
echo ""
echo ""
echo "-------------------------->"
echo ""
echo ""
rm -r C:\SCRIPT\$fname\
echo "DELETED"
echo ""
echo ""
echo "CREATING NEW DIRECTORY"
echo ""
echo ""
echo "-------------------------->"
echo ""
echo ""
mkdir c:\SCRIPT\$fname
echo "CREATED"
echo ""
echo ""
}
else
{
echo ""
echo ""
echo "CREATING DIRECTORY"
echo ""
echo ""
echo "------------------------->"
echo ""
echo ""
mkdir c:\SCRIPT\$fname
echo "CREATED"
echo ""
echo ""
}
echo ""
echo "EXPORTING MAILBOX DATABASES TO EXCEL "
echo ""
echo ""
echo "C:\SCRIPT\$fname\ "
echo ""
echo ""
echo "-------------------------------------------------------------->"
Get-MailboxDatabase "Executive2010" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\Executive2010.csv
Get-MailboxDatabase "ExecutiveII2010" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\ExecutiveII2010.csv
Get-MailboxDatabase "Australia_NewZealand" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\Australia_NewZealand.csv
Get-MailboxDatabase "mytestorgBPONewDB" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\mytestorgBPONewDB.csv
Get-MailboxDatabase "mytestorgHealth2010" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\mytestorgHealth2010.csv
Get-MailboxDatabase "ParkCity" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\ParkCity.csv
Get-MailboxDatabase "Pasadena" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\Pasadena.csv
Get-MailboxDatabase "mytestorgLatinAmerica" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\mytestorgLatinAmerica.csv
Get-MailboxDatabase "mytestorgUS_NewDB" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\mytestorgUS_NewDB.csv
Get-MailboxDatabase "Misc" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\Misc.csv
Get-MailboxDatabase "mytestorg_India_ManagersDB" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\mytestorg_India_ManagersDB.csv
Get-MailboxDatabase "Corp" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\Corp.csv
Get-MailboxDatabase "ExecutiveMain" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\ExecutiveMain.csv
Get-MailboxDatabase "mytestorg_India_Development" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\mytestorg_India_Development.csv
Get-MailboxDatabase "mytestorg_Herndon_NewDB" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\mytestorg_Herndon_NewDB.csv
Get-MailboxDatabase "SandiegoNewDB" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\SandiegoNewDB.csv
Get-MailboxDatabase "mytestorgAtlanta" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\mytestorgAtlanta.csv
Get-MailboxDatabase "TermDatabase" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\TermDatabase.csv
Get-MailboxDatabase "mytestorg_Hyderabad" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\mytestorg_Hyderabad.csv
Get-MailboxDatabase "mytestorgEurope" | Get-Mailboxstatistics | Sort totalitemsize -desc | Export-CSV c:\SCRIPT\$fname\mytestorgEurope.csv

echo "MAILBOXES HAS BEEN EXPORTED TO SPREADSHEETS"
echo ""
echo ""
echo "EXPORTED SPREADSHEETS ARE FOLLOWS"
cd c:\SCRIPT\$fname
ls
$i=0

Get-ChildItem -Path c:\SCRIPT\$fname\ -Recurse -Force |

foreach-object { $i++ }
echo ""
echo "TOTAL EXPORTED FILES:"$i
echo "***********************************************************************************************************************************************************************************************************"

