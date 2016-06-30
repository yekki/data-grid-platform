#!/bin/bash  

source ./bin/comm_env.sh

_NODE_NAME=
_ACTION=

while getopts "n:arskhcqj" arg  
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
			_ACTION="cleanup"
		;;
		a)
			_ACTION="console"
		;;
		q)
			_ACTION="query"
		;;
		j)
			_ACTION="jmx"
		;;
		h)  
			usage
		;;
		*)
			usage
		;;
	esac
done


if [[ "start stop status cleanup console query jmx" =~ "${_ACTION}" ]]
then
	if [ -n "${_NODE_NAME}" ]
	then
		${_ACTION}_node $_NODE_NAME
	else
		if [[ "query console jmx" =~ "${_ACTION}" ]]; then ${_ACTION}; exit 0; fi
					
		for dn in ${DGP_RUNNING_NODES[@]}; do
			${_ACTION}_node $dn
		done
	fi
fi
