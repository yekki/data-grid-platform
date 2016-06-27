#!/bin/bash  

source ./bin/comm_env.sh

_NODE_NAME=
_ACTION=

while getopts "n:rskhc" arg  
do
	case $arg in  
		n)  
			_NODE_NAME=$OPTARG
		;;
		r)  
			_ACTION="start"
		;;
		k)
			_ACTION="stop" 
		;;
		s)
			_ACTION="status"
		;;
		c)
			rm -rf ${DGP_NODES_HOME}/logs && mkdir ${DGP_NODES_HOME}/logs && echo "cleanup all logs"
		;;
		h)  
			usage
		;;
		*)
			usage
		;;
	esac
done


if [[ "start stop status" =~ "${_ACTION}" ]]
then
	if [ -n "${_NODE_NAME}" ]
	then
		${_ACTION}_node $_NODE_NAME
	else
		for dn in ${DGP_RUNNING_DATA_NODES[@]}; do
			${_ACTION}_node $dn
		done
	fi
fi
