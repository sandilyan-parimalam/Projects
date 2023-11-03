#!/bin/bash
#this script will start the containers in ASPLINVZ and LIN3VZ

server_name=$1
cid=$2

if [ "${server_name}" == "linvz" ] && [ ! -z "${cid}" ] ; then

        ssh root@asplinvz "vzctl start ${cid}"

elif [ "${server_name}" == "lin3vz" ] && [ ! -z "${cid}" ]; then

        ssh root@asplin3vz.mytestorghealth.com "vzctl start ${cid}"


else

        echo "Please provide linvz or lin3vz also the container ID as an argument to this script"

fi
