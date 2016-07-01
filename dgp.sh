#!/usr/bin/env bash
 
source ./bin/comm_env.sh

_NODE_NAME=
_ACTION=

while getopts "n:arskhcqj" arg  
do
	case $arg in  
		n)  
			_NODE_NAME=$OPTARG
		;;
		r | k | s | c | a | q | h | j)  
			_ACTION=$arg
		;;
		*)
			usage
		;;
	esac
done

if [[ "s k r c a q j h" =~ "${_ACTION}" ]]
then
	if [ -n "${_NODE_NAME}" ]
	then
		"${GDP_COMMANDS[${_ACTION}]}" $_NODE_NAME
	else
		if [[ "q a j h" =~ "${_ACTION}" ]]; then "${GDP_COMMANDS[${_ACTION}]}"; exit 0; fi
					
		for dn in ${DGP_RUNNING_NODES[@]}; do
			"${GDP_COMMANDS[${_ACTION}]}" $dn
		done
	fi
fi
