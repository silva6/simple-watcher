#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Usage:$0 file_name [watch_dog=true]"
    exit 1
fi

file_name=$1
service_name=`ls ${file_name}-*.proc 2>/dev/null | sort -r | head -1`

if [[ "${service_name}" = "" ]]; then
	echo "killing service is not found"
	exit 1;
fi

if [ "$2" = "true" ]
then
	pid=`ps -ef | grep "watch_service.sh ${file_name}" | grep -v grep |awk '{print $2}'`
	if [ "${pid}" = "" ]
	then
		echo "watch dog is gone"
	else
		kill -15 $pid
		echo "watch dog is stoped"
	fi
fi

killall -15 ${service_name}
echo "${service_name} is stoped"

rm -f ${file_name}-*.proc

