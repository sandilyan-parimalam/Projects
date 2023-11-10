#This script is developed to feed adamexchange table, from the csv file which is located on ftp

#						 V A R I A B L E S -->
FTP_NAME=192.168.64.16
FTP_USER=exchange-db
FTP_PWD=ATL@EXG918
FTP_DIR="/ADAM-EXCH-DB/"
FNAME="ADAM-Mailbox-List-1-7-14.csv"


#						 F U N C T I O N S -->

function download() {
#Download csv file
ftp -ivn ${FTP_NAME} << SESSION
user ${FTP_USER} ${FTP_PWD}
bin
cd ${FTP_DIR}
get ${FNAME}
close
bye
SESSION
}

function edit() {
#Delete unwanted headings from the file
sed -i 1,2d ${FNAME}
}

function feed() {
#Feed into the DB
mysql -u root ocsweb << EOF
load data local infile 'ADAM-Mailbox-List-15-7-14.csv' into table adamexchange fields terminated by ',' enclosed by '"' lines terminated by '\n' (DisplayName,TotalItemSize,ItemCount,DatabaseName);
EOF
}

#					BOS
download
edit
feed

