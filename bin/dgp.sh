#!/bin/bash  

source ../sbin/comm_env.sh

function usage {

cat <<EOF
Usage: $0 [-n node_name] [-s] [-k]

-n: coherence node name, no the option means all nodes
-s: start node name
-k: stop node name

EOF
	exit 0
}

_NODE_NAME=
_ACTION=

while getopts "n:sk" arg  
do
	case $arg in  
		n)  
			_NODE_NAME=$OPTARG
		;;
		s)  
			_ACTION="start"
		;;
		k)
			_ACTION="stop" 
		;;   
		?)  
			usage
		;;  
	esac
done

function start_node {
	source ../sbin/node_env.sh $1
	${JAVA_HOME}/bin/java -cp $CLASSPATH -Dcoherence.server.name=${DGP_NODE_NAME} ${JAVA_OPTIONS} com.tangosol.net.DefaultCacheServer  2>&1 | cronolog ${DGP_NODES_HOME}/logs/${DGP_NODE_NAME}-%Y%m%d.log &
	echo "${DGP_NODE_NAME}.................[started]"
}

function stop_node {
	source ../sbin/node_env.sh $1

	ps -ef|grep ${DGP_DATA_PROCESS_NAME} |grep `whoami` | grep ${DGP_NODE_NAME} | grep java | grep -v grep | awk '{print $2}' |while read pid

	do
		kill ${pid} 2>&1 >/dev/null
		echo "${DGP_NODE_NAME}.................[stopped]"
	done
}

if [ -n "${_NODE_NAME}" ]
then
	if [ "${_ACTION}" == "start" ]
	then
		start_node $_NODE_NAME
	elif [ "${_ACTION}" == "stop" ]; then
		stop_node $_NODE_NAME
	else
		usage
	fi
else
	if [ "${_ACTION}" == "start" ]
	then
		for dn in ${DGP_RUNNING_DATA_NODES[@]}; do
			start_node $dn
		done
	elif [ "${_ACTION}" == "stop" ]; then
		for dn in ${DGP_RUNNING_DATA_NODES[@]}; do
			stop_node $dn
		done
	else
		usage
	fi
fi