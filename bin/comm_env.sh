#!/bin/bash

DGP_HOME=/Users/gniu/Workspaces/data-grid-platform
DGP_SIDE=server
DGP_RUNNING_DATA_NODES=(node01 node02)
DGP_RUNNING_PROXY_NODES=(proxy1 proxy2)
DGP_VERBOSE=false
DGP_CLASSPATH=${COHERENCE_HOME}/lib/coherence.jar
DGP_TOOL_MEM_ARGS="-Xms128m -Xmx256m"

DGP_DATA_PROCESS_NAME=DefaultCacheServer

COHERENCE_HOME=/Users/gniu/Oracle/mw12c/coherence
JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_92.jdk/Contents/Home

JAVA_OPTIONS="-Djava.net.preferIPv4Stack=true"

function _log {

	if $DGP_VERBOSE; then echo "* ${1}"; fi
}

#$1: msg $2:verbose(true:show)
function _msg {

	if [ ! $2 ]; then echo $1; fi
}

function start_node {
	source ${DGP_HOME}/bin/node_env.sh $1

	_msg "${JAVA_HOME}/bin/java -cp $CLASSPATH -Dcoherence.server.name=${DGP_NODE_NAME} ${JAVA_OPTIONS} com.tangosol.net.DefaultCacheServer" DGP_VERBOSE
	
	status_node ${DGP_NODE_NAME} false
	_PC1=$?
	
	${JAVA_HOME}/bin/java -cp $CLASSPATH -Dcoherence.server.name=${DGP_NODE_NAME} ${JAVA_OPTIONS} com.tangosol.net.DefaultCacheServer  2>&1 | cronolog ${DGP_HOME}/nodes/logs/${DGP_NODE_NAME}-%Y%m%d.log &

	status_node ${DGP_NODE_NAME} false
	_PC2=$?
	
	if [[ $_PC2 > $_PC1 ]]
	then
		echo "${DGP_NODE_NAME}.................[started]"
	else
		echo "${DGP_NODE_NAME}.................[failed]"
	fi
}

function stop_node {
	source ${DGP_HOME}/bin/node_env.sh $1

	ps -ef|grep ${DGP_DATA_PROCESS_NAME} | grep `whoami` | grep ${DGP_NODE_NAME} | grep java | grep -v grep | awk '{print $2}' | while read pid

	do
		kill ${pid} 2>&1 >/dev/null
		echo "${DGP_NODE_NAME}.................[stopped]"
	done
}
# $1: node name, $2:verbose(true:show)
function status_node {
	source ${DGP_HOME}/bin/node_env.sh $1
	_PROCESS_COUNT=0
	ps -ef |grep ${DGP_DATA_PROCESS_NAME} | grep `whoami` | grep ${DGP_NODE_NAME} | grep java | grep -v grep | awk '{print $2}' | (while read pid
	do
        _PROCESS_COUNT=`expr $_PROCESS_COUNT + 1`
	done

	if [ ${_PROCESS_COUNT} -gt 0 ];
	then
		_B1=is
		_B2=
		if [[ ${_PROCESS_COUNT} > 1 ]]; then _B1=are; _B2=es; fi

		_msg "${_PROCESS_COUNT} ${DGP_DATA_PROCESS_NAME} process${_B2} for ${DGP_NODE_NAME} $_B1 running." $2

		return $_PROCESS_COUNT
	else
		_msg "0 ${DGP_DATA_PROCESS_NAME} process for ${DGP_NODE_NAME} is running" $2

		return 0
	fi)
}

function cleanup_node {
	source ${DGP_HOME}/bin/node_env.sh $1
	rm -rf ${DGP_HOME}/nodes/logs/${DGP_NODE_NAME}*.log
}

function console {
	source ${DGP_HOME}/bin/node_env.sh console tools
	${JAVA_HOME}/bin/java -server -showversion ${DGP_TOOL_MEM_ARGS} ${JAVA_OPTIONS} -cp $CLASSPATH com.tangosol.net.CacheFactory
}

function query {

	source ${DGP_HOME}/bin/node_env.sh query tools
	${JAVA_HOME}/bin/java -server -showversion ${DGP_TOOL_MEM_ARGS} ${JAVA_OPTIONS} -cp $CLASSPATH:${COHERENCE_HOME}/lib/jline.jar com.tangosol.coherence.dslquery.QueryPlus
}

function usage {

cat <<EOF
Usage: $0 [-n node_name] [-r] [-k] [-c] [-s]

-n: coherence node name, no the option means all nodes
-r: start node(s)
-k: stop node(s)
-c: cleanup node(s)
-s: node(s) status
-a: console tool
-q: query tool
EOF
	exit 0
}