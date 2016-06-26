#!/bin/bash

DGP_HOME=/Users/gniu/Workspaces/data-grid-platform
DGP_SIDE=server
DGP_RUNNING_DATA_NODES=(node01 node02)
DGP_RUNNING_PROXY_NODES=(proxy1 proxy2)
DGP_VERBOSE=false
DGP_CLASSPATH=${COHERENCE_HOME}/lib/coherence.jar

COHERENCE_HOME=/Users/gniu/Oracle/mw12c/coherence
JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home


DGP_NODES_HOME=${DGP_HOME}/nodes
DGP_LIB_HOME=${DGP_HOME}/lib
DGP_CONFIG_HOME=${DGP_HOME}/config
DGP_TOPOLOGY_HOME=${DGP_HOME}/topology
DGP_DATA_PROCESS_NAME=DefaultCacheServer

DGP_NODES_OPTS_FILE=${DGP_CONFIG_HOME}/${DGP_SIDE}-opts.properties

JAVA_OPTIONS="-Djava.net.preferIPv4Stack=true"
JAVA_MEM_ARGS="-Xms1024m -Xmx1024m -XX:+DisableExplicitGC -XX:+HeapDumpOnOutOfMemoryError -verbosegc -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+PrintHeapAtGC -Xloggc:${SERVERS_HOME}/logs/${SERVER_NAME}_gc.log -XX:HeapDumpPath=${DGP_NODES_HOME}/logs"


function _log {

	if $DGP_VERBOSE; then echo ">>${1}"; fi
}

function start_node {
	source ${DGP_HOME}/bin/node_env.sh $1
	${JAVA_HOME}/bin/java -cp $CLASSPATH -Dcoherence.server.name=${DGP_NODE_NAME} ${JAVA_OPTIONS} com.tangosol.net.DefaultCacheServer  2>&1 | cronolog ${DGP_NODES_HOME}/logs/${DGP_NODE_NAME}-%Y%m%d.log &
	echo "${DGP_NODE_NAME}.................[started]"
}

function stop_node {
	source ${DGP_HOME}/bin/node_env.sh $1

	ps -ef|grep ${DGP_DATA_PROCESS_NAME} |grep `whoami` | grep ${DGP_NODE_NAME} | grep java | grep -v grep | awk '{print $2}' |while read pid

	do
		kill ${pid} 2>&1 >/dev/null
		echo "${DGP_NODE_NAME}.................[stopped]"
	done
}

function usage {

cat <<EOF
Usage: $0 [-n node_name] [-s] [-k] [-c]

-n: coherence node name, no the option means all nodes
-s: start node(s)
-k: stop node(s)
-c: cleanup all logs
EOF
	exit 0
}