#!/bin/bash
COH_LAUNCH_FILE=/Users/gniu/Workspaces/data-grid-platform/domain/config/coh_opts.properties

COHERENCE_OPTIONS=`awk '/^'"$1"'/{len=length("'$1'");ops=ops" -D"substr($0,len+2)} END {print ops}' $COH_LAUNCH_FILE`
echo $COHERENCE_OPTIONS