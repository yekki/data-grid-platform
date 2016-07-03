#!/usr/bin/env bash

source $DGP_HOME/bin/comm_env.sh

if [ "$1" == "" ]; then
	echo "error: missing node name"
	exit 1
else
    DGP_NODE_NAME=$1
fi

if [[ "$DGP_MEM_ARGS_OVERRIDE" = "" ]]
then
    DGP_MEM_ARGS="-Xms1024m -Xmx1024m -XX:+DisableExplicitGC -XX:+HeapDumpOnOutOfMemoryError -verbosegc -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+PrintHeapAtGC -Xloggc:$DGP_HOME/nodes/logs/$DGP_NODE_NAME_gc.log -XX:HeapDumpPath=$DGP_HOME/nodes/logs"
else
    DGP_MEM_ARGS=$DGP_MEM_ARGS_OVERRIDE
fi

for file in $DGP_HOME/lib/*.jar;
do DGP_CLASSPATH=${DGP_CLASSPATH}:$file;
done

CLASSPATH="$DGP_HOME/topology:$DGP_HOME/config:$DGP_CLASSPATH"

if [ "$2" != "" ]; then DGP_NODE_TYPE="$2"; fi

DGP_NODES_OPTS_FILE="$DGP_HOME/nodes/config/$DGP_NODE_TYPE-opts.properties"
DGP_NODES_COMMON_OPTS_FILE="$DGP_HOME/nodes/config/common-opts.properties"

if [ -f ${DGP_NODES_OPTS_FILE} ]
then
    OPT_STR1=`awk '/^'"$1"'/{len=length("'$1'");ops=ops" -D"substr($0,len+2)} END {print ops}' $DGP_NODES_OPTS_FILE`
fi

if [ -f ${DGP_NODES_COMMON_OPTS_FILE} ]
then
	OPT_STR2=`awk '/^'"common"'/{len=length("'common'");ops=ops" -D"substr($0,len+2)} END {print ops}' $DGP_NODES_COMMON_OPTS_FILE`
fi

# merge node java args, node java args will override common java args.
OPT_A1=(${OPT_STR1///})  
OPT_A2=(${OPT_STR2///})
OPT_A3=()

for arg1 in ${OPT_A1[@]}
do
    IFS='=' read -r -a array1 <<< $arg1

    for arg2 in ${OPT_A2[@]}
    do
        IFS='=' read -r -a array2 <<< $arg2

        if [[ ${array1[0]} = ${array2[0]} ]]
        then
            OPT_A3+=($arg2)
        fi
    done
done

for item in ${OPT_A3[@]}; do OPT_A2=(${OPT_A2[@]/$item/}); done

OPT_A3=(${OPT_A1[@]} ${OPT_A2[@]})

for item in ${OPT_A3[@]}; do COHERENCE_OPTIONS="$COHERENCE_OPTIONS $item"; done

if [[ "$COHERENCE_OPTIONS" = "" ]] 
then
	echo "error: coherence node $DGP_NODE_NAME launch options is empty!"
	exit 1
fi

JAVA_OPTIONS="$DGP_MEM_ARGS $COHERENCE_OPTIONS $JAVA_OPTIONS"

function verbose {
_log ""
_log ""
_log "***************************************************************************"
_log "DGP_HOME=$DGP_HOME"
_log ""
_log "DGP_NODE_NAME=$DGP_NODE_NAME"
_log ""
_log "DGP_NODE_TYPE=$DGP_NODE_TYPE"
_log ""
_log "JAVA_HOME=$JAVA_HOME"
_log ""
_log "JAVA_OPTIONS=$JAVA_OPTIONS"
_log ""
_log "COHERENCE_HOME=$COHERENCE_HOME"
_log ""
_log "COHERENCE_OPTIONS=$COHERENCE_OPTIONS"
_log ""
_log "CLASSPATH=$CLASSPATH"
_log "***************************************************************************"
_log ""
_log ""
}