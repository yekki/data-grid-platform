#!/bin/bash
source ../sbin/comm_env.sh
source ../sbin/node_env.sh $1

${JAVA_HOME}/bin/java -cp $CLASSPATH -Dcoherence.server.name=${DGP_NODE_NAME} ${JAVA_OPTIONS} com.tangosol.net.DefaultCacheServer  2>&1 | cronolog ${DGP_NODES_HOME}/logs/${DGP_NODE_NAME}-%Y%m%d.log &
echo "${DGP_NODE_NAME}.................[started]"