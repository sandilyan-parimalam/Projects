#!/bin/bash
for x in `vzlist | egrep -v 'CTID|test|train' | acol 1`
do 

vzctl exec $x 'for i in `find /usr/local/ | grep catalina.sh | grep -v .bkp` ; do sed -i "s#-Dini.path#-XX:PermSize=256m -XX:MaxPermSize=512m -Dini.path#" $i ; done'
#vzctl exec $x 'for i in `find /usr/local/ | grep catalina.sh | grep -v .bkp` ; do echo $i ; done'
done 
