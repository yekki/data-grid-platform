#!/bin/bash

if [ "$1" == "" ]; then
	echo "missing node name"
	exit 1
fi

SERVER_NAME=$1

echo "***************************************************************************"
echo "<<< 初始化Coherence集群环境参数"

echo "JAVA_HOME=${JAVA_HOME}"
echo "DGP_HOME=${DGP_HOME}"
echo "COHERENCE_HOME=${COHERENCE_HOME}"
echo "JAVA_OPTIONS=${JAVA_OPTIONS}"

COMMON_LIB_HOME="${DGP_HOME}/lib"
export COMMON_LIB_HOME
echo "COMMON_LIB_HOME=${COMMON_LIB_HOME}"

COMMON_LIBEXT_HOME="${DGP_HOME}/libext"
export COMMON_LIBEXT_HOME
echo "COMMON_LIBEXT_HOME=${COMMON_LIBEXT_HOME}"

COMMON_CONFIG_HOME="${DGP_HOME}/config"
echo "COMMON_CONFIG_HOME=${COMMON_CONFIG_HOME}"

COMMON_CONFIGEXT_HOME="${DGP_HOME}/configext"
echo "COMMON_CONFIGEXT_HOME=${COMMON_CONFIGEXT_HOME}"

CP=
for file in ${COHERENCE_HOME}/lib/*.jar;
do CP=${CP}:$file;
done

for file in ${COMMON_LIBEXT_HOME}/*;
do CP=${CP}:$file;
done

for file in ${COMMON_LIB_HOME}/*;
do CP=${CP}:$file;
done

CLASSPATH="${COMMON_CONFIGEXT_HOME}:${COMMON_CONFIG_HOME}:${CP}"
export CLASSPATH

COH_LAUNCH_FILE="${DGP_HOME}/config/${DGP_SIDE}-opts.properties"

if [[ $1 != "" && -f $COH_LAUNCH_FILE ]] 
then
	COHERENCE_OPTIONS=`awk '/^'"$1"'/{len=length("'$1'");ops=ops" -D"substr($0,len+2)} END {print ops}' $COH_LAUNCH_FILE`
fi

echo "CLASSPATH=$CLASSPATH"
echo "COHERENCE_OPTIONS=$COHERENCE_OPTIONS"

echo ">>> 初始化Coherence集群环境参数完成"
echo "***************************************************************************"
