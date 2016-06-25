#!/bin/bash

source ./init_node_env.sh

CURRENT_USER=`whoami`

PROCESS_PARM="d010104_market"

ps -ef|grep $PROCESS_NAME |grep ${CURRENT_USER} | grep $DGP_NODE_NAME | grep java | grep -v grep | awk '{print $2}' |while read pid

do
        kill ${pid} 2>&1 >/dev/null
        echo "进程名称:${PROCESS_NAME},参数:${PROCESS_PARM},PID:${pid} 成功停止"
done