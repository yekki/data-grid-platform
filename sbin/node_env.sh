#!/bin/bash

source ${DGP_HOME}/sbin/comm_env.sh

if [ "$1" == "" ]; then
	echo "error: missing node name"
	exit 1
fi

DGP_NODE_NAME=$1

for file in ${DGP_LIB_HOME}/*.jar;
do DGP_CLASSPATH=${DGP_CLASSPATH}:$file;
done

CLASSPATH="${DGP_TOPOLOGY_HOME}:${DGP_CONFIG_HOME}:${DGP_CLASSPATH}"


if [ -f $DGP_NODES_OPTS_FILE ]
then
	COHERENCE_OPTIONS=`awk '/^'"$1"'/{len=length("'$1'");ops=ops" -D"substr($0,len+2)} END {print ops}' $DGP_NODES_OPTS_FILE`
fi

if [[ $COHERENCE_OPTIONS = "" ]] 
then
	echo "error: coherence node ${DGP_NODE_NAME} launch options is empty!"
	exit 1
fi


JAVA_OPTIONS="${COHERENCE_OPTIONS} ${JAVA_OPTIONS}"

_log "***************************************************************************"
_log "DGP_NODE_NAME=${DGP_NODE_NAME}"
_log "DGP_HOME=${DGP_HOME}"
_log "DGP_LIB_HOME=${DGP_LIB_HOME}"
_log "DGP_CONFIG_HOME=${DGP_CONFIG_HOME}"
_log "DGP_SIDE=${DGP_SIDE}"
_log "DGP_TOPOLOGY_HOME=${DGP_TOPOLOGY_HOME}"
_log "JAVA_HOME=${JAVA_HOME}"
_log "JAVA_OPTIONS=${JAVA_OPTIONS}"
_log "COHERENCE_HOME=${COHERENCE_HOME}"
_log "COHERENCE_OPTIONS=${COHERENCE_OPTIONS}"
_log "CLASSPATH=${CLASSPATH}"
_log "***************************************************************************"
