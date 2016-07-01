#!/usr/bin/env bash

############## global environemnt variables ##############

DGP_HOME=/Users/gniu/Workspaces/data-grid-platform
DGP_NODE_TYPE=nodes
DGP_RUNNING_NODES=(node01 node02 mgmt)
DGP_VERBOSE=false
GDP_DEBUG=false
DGP_CLASSPATH=$COHERENCE_HOME/lib/coherence.jar
DGP_TOOL_MEM_ARGS="-Xms128m -Xmx256m"
DGP_PROCESS_NAME=DefaultCacheServer

COHERENCE_HOME=/Users/gniu/Oracle/mw12c/coherence
JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_92.jdk/Contents/Home

JAVA_OPTIONS="-Djava.net.preferIPv4Stack=true"

####################### commands ########################

declare -A GDP_COMMANDS=( ["h"]="usage" ["q"]="query" ["c"]="cleanup_node" ["a"]="console" ["j"]="jmx" ["r"]="start_node" ["s"]="status_node"  ["k"]="stop_node" )

####################### functions ########################

function _log {

	if $DGP_VERBOSE; then echo "* ${1}"; fi
}

# $1: node name, $2:verbose(true:show)
function status_node {
	source $DGP_HOME/bin/node_env.sh $1
	
	_PROCESS_COUNT=0

	if [[ $2 = true ]] || [[ "$2" = "" ]]; then verbose; fi

	ps -ef |grep $DGP_PROCESS_NAME | grep `whoami` | grep $DGP_NODE_NAME | grep java | grep -v grep | awk '{print $2}' | (while read pid
	do
		(( _PROCESS_COUNT = _PROCESS_COUNT + 1 ))
	done

	if [[ $_PROCESS_COUNT > 0 ]];
	then
		_B1=is
		_B2=
		if [[ $_PROCESS_COUNT > 1 ]]; then _B1=are; _B2=es; fi

		if [[ $2 = true ]] || [[ "$2" = "" ]]; then echo "$_PROCESS_COUNT $DGP_PROCESS_NAME process$_B2 for $DGP_NODE_NAME $_B1 running."; fi

		return $_PROCESS_COUNT
	else
		if [[ $2 = true ]] || [[ "$2" = "" ]]; then echo "0 $DGP_PROCESS_NAME process for $DGP_NODE_NAME is running"; fi

		return 0
	fi)
}

function start_node {

	source $DGP_HOME/bin/node_env.sh $1

	verbose

	status_node $DGP_NODE_NAME false
	_PC1=$?
	
	if [ ! $DGP_DEBUG ]
	then
		$JAVA_HOME/bin/java -cp $CLASSPATH -Dcoherence.server.name=$DGP_NODE_NAME $JAVA_OPTIONS com.tangosol.net.DefaultCacheServer  2>&1 | cronolog $DGP_HOME/nodes/logs/$DGP_NODE_NAME-%Y%m%d.log &
	fi

	status_node $DGP_NODE_NAME false
	_PC2=$?
	
	if [[ $_PC2 > $_PC1 ]]
	then
		echo "$DGP_NODE_NAME.................[started]"
	else
		echo "$DGP_NODE_NAME.................[failed]"
	fi
}

function stop_node {

	source $DGP_HOME/bin/node_env.sh $1

	verbose

	ps -ef|grep $DGP_PROCESS_NAME | grep `whoami` | grep $DGP_NODE_NAME | grep java | grep -v grep | awk '{print $2}' | while read pid

	do
		kill ${pid} 2>&1 >/dev/null
		echo "$DGP_NODE_NAME.................[stopped]"
	done
}

function cleanup_node {
	source $DGP_HOME/bin/node_env.sh $1
	rm -rf $DGP_HOME/nodes/logs/$DGP_NODE_NAME*.log
}

function console {
	source $DGP_HOME/bin/node_env.sh console tools
	${JAVA_HOME}/bin/java -server -showversion $DGP_TOOL_MEM_ARGS $JAVA_OPTIONS -cp $CLASSPATH com.tangosol.net.CacheFactory
}

function query {

	source $DGP_HOME/bin/node_env.sh query tools
	$JAVA_HOME/bin/java -server -showversion $DGP_TOOL_MEM_ARGS $JAVA_OPTIONS -cp $CLASSPATH:$COHERENCE_HOME/lib/jline.jar com.tangosol.coherence.dslquery.QueryPlus
}

function jmx {
	source $DGP_HOME/bin/node_env.sh jmx tools
	$JAVA_HOME/bin/java -server -showversion $DGP_TOOL_MEM_ARGS $JAVA_OPTIONS -cp $CLASSPATH:$DGP_HOME/lib/ext/jmx/jmxri.jar:$DGP_HOME/lib/ext/jmx/jmxtools.jar com.tangosol.net.CacheFactory
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