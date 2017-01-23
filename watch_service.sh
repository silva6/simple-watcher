#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Usage:$0 file_name"
    exit 1
fi

file_name=$1

while :
do
	service_name=`ls ${file_name}-*.proc 2>/dev/null | sort -r | head -1`

	if [ "${service_name}" = "" ]
	then
		./start_service.sh ${file_name}
	else
		pid=`ps -ef | grep "${service_name}" | grep -v grep |awk '{print $2}'`
		# 如果为空,表示进程异常退出
		if [ "${pid}" = "" ]
		then
			mv ${service_name} core-${service_name}
			./start_service.sh ${file_name}
		else
			echo running
		fi
	fi
	sleep 1
done
