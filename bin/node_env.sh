#!/bin/bash

source ${DGP_HOME}/bin/comm_env.sh

if [ "$1" == "" ]; then
	echo "error: missing node name"
	exit 1
else
    DGP_NODE_NAME=$1
fi

DGP_NODE_MEM_ARGS="-Xms1024m -Xmx1024m -XX:+DisableExplicitGC -XX:+HeapDumpOnOutOfMemoryError -verbosegc -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+PrintHeapAtGC -Xloggc:${DGP_HOME}/nodes/logs/${DGP_NODE_NAME}_gc.log -XX:HeapDumpPath=${DGP_HOME}/nodes/logs"

for file in ${DGP_HOME}/lib/*.jar;
do DGP_CLASSPATH=${DGP_CLASSPATH}:$file;
done

CLASSPATH="${DGP_HOME}/topology:${DGP_HOME}/config:${DGP_CLASSPATH}"

if [ "$2" != "" ]; then DGP_SIDE="$2"; fi

DGP_NODES_OPTS_FILE="${DGP_HOME}/config/${DGP_SIDE}-opts.properties"

if [ -f $DGP_NODES_OPTS_FILE ]
then
	COHERENCE_OPTIONS=`awk '/^'"$1"'/{len=length("'$1'");ops=ops" -D"substr($0,len+2)} END {print ops}' $DGP_NODES_OPTS_FILE`
fi

if [[ $COHERENCE_OPTIONS = "" ]] 
then
	echo "error: coherence node ${DGP_NODE_NAME} launch options is empty!"
	exit 1
fi

JAVA_OPTIONS="${DGP_NODE_MEM_ARGS} ${COHERENCE_OPTIONS} ${JAVA_OPTIONS}"

_log "***************************************************************************"
_log "DGP_NODE_NAME=${DGP_NODE_NAME}"
_log "DGP_HOME=${DGP_HOME}"
_log "DGP_SIDE=${DGP_SIDE}"
_log "JAVA_HOME=${JAVA_HOME}"
_log "JAVA_OPTIONS=${JAVA_OPTIONS}"
_log "COHERENCE_HOME=${COHERENCE_HOME}"
_log "COHERENCE_OPTIONS=${COHERENCE_OPTIONS}"
_log "CLASSPATH=${CLASSPATH}"
_log "***************************************************************************"
