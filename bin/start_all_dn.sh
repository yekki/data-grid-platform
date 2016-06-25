#!/bin/bash

source "./_comm_env.sh"

for dn in ${RUNNING_DATA_NODES[@]}; do
	source ./start_server.sh $dn	
done
