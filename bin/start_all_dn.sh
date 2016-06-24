#!/bin/bash

source "./comm_env.sh"
source "./config/server-runtime.properties"

for dn in ${RUNNING_DATA_NODES[@]}; do
	source ./init_env.sh $dn
	#启动命令行
	$JAVA_HOME/bin/java $JAVA_MEM_ARGS -Dcoherence.server.name=$SERVER_NAME $JAVA_OPTIONS com.tangosol.net.DefaultCacheServer  2>&1 | ${DGP_HOME}/bin/cronolog -k 14 ${SERVERS_HOME}/logs/${SERVER_NAME}-%Y%m%d.log &
done

for file in `find $DOMAIN_HOME/servers -name "start*.sh"`
do
        cd `dirname $file`
        ./`basename $file` > /dev/null 2>&1 &
    sleep 1
        echo "${file}....................[ok]"
done