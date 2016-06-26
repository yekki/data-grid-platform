#!/bin/bash

DGP_HOME=/Users/gniu/Workspaces/data-grid-platform
DGP_SIDE=server
DGP_NODES_HOME=${DGP_HOME}/nodes
DGP_LIB_HOME=${DGP_HOME}/lib
DGP_CONFIG_HOME=${DGP_HOME}/config
DGP_TOPOLOGY_HOME=${DGP_HOME}/topology
DGP_VERBOSE=false
DGP_DATA_PROCESS_NAME=DefaultCacheServer
DGP_RUNNING_DATA_NODES=(node01 node02)
DGP_RUNNING_PROXY_NODES=(proxy1 proxy2)
DGP_CLASSPATH=${COHERENCE_HOME}/lib/coherence.jar
DGP_NODES_OPTS_FILE=${DGP_CONFIG_HOME}/${DGP_SIDE}-opts.properties
DGP_CMD_START_NODE=${DGP_HOME}/bin/start.sh
DGP_CMD_STOP_NODE=${DGP_HOME}/bin/stop.sh

JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home
JAVA_OPTIONS="-Djava.net.preferIPv4Stack=true"
JAVA_MEM_ARGS="-Xms8192m -Xmx8192m  -XX:+DisableExplicitGC -XX:+HeapDumpOnOutOfMemoryError -verbosegc -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+PrintHeapAtGC -Xloggc:${SERVERS_HOME}/logs/${SERVER_NAME}_gc.log -XX:HeapDumpPath=${SERVERS_HOME}/logs"

COHERENCE_HOME=/Users/gniu/Oracle/mw12c/coherence

function _log {

	if $DGP_VERBOSE; then echo ">>${1}"; fi
}
