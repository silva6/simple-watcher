#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Usage:$0 file_name [watch_dog=true]"
    exit 1
fi

if [[ ! -x $1 ]]; then
	echo "$1 is not executable!"
	exit 1
fi

file_name=$1
service_name="${file_name}-`date '+%s'`.proc"

# stop old service first
./stop_service.sh ${file_name} $2

ln -s ${file_name} ${service_name}

ulimit -c 40000
# run background
nohup ./${service_name} >../log/${service_name}.txt 2>&1 &
echo "${service_name} start success"

[ "$2" = "true" ] || exit

./watch_service.sh ${file_name}>/dev/null 2>&1 &
echo "watch dog start success"
